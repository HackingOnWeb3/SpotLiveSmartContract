// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SpotLive is ERC721URIStorage{
    
    //current pending token id
    uint256 public currentTokenID;

    //how much points a token id have
    mapping(uint256 => uint256) public tokenPoints;

    //max points a pass have
    uint256 public maxPoints = 10;

    //total supply of tokens
    mapping (address => uint256) public liveSupplyMap;


    //checkin data
    struct CheckInInfo {
        //经纬度
        uint256 latitude;

        //
        uint256 longitude;

        //时间
        uint256 time;

        //is origin point
        bool origin;

        address belongToScope;
    }

    //array of all checked in users
    CheckInInfo[] public checkInList;

    //scope map
    mapping (address => CheckInInfo) public scopeMap;

    //scope=>member 
    mapping (address => address[]) public scopeMembersMap;


    //array of origin with address
    address[] public originList;

    //scope => token id list
    mapping (address => uint256[]) public scopeTokenList;

    // checkinmembers
    // 
    mapping (address => CheckInInfo[]) public memberCheckList;

    //string memory name, string memory symbol
    constructor() ERC721("PASSToken", "PASS") {
        currentTokenID = 0;
    }
    // function setNumber(uint256 newNumber) public {
    //     currentTokenID = newNumber;
    // }

    // function increment() public {
    //     currentTokenID++;
    // }


    function getPriceByLive( address live, uint256 amount) public view returns (uint256) {

        uint256 supply = scopeTokenList[live].length;
        uint256 sum1 = supply == 0 ? 0 : (supply - 1 )* (supply) * (2 * (supply - 1) + 1) / 6;
        uint256 sum2 = supply == 0 && amount == 1 ? 0 : (supply - 1 + amount) * (supply + amount) * (2 * (supply - 1 + amount) + 1) / 6;
        uint256 summation = sum2 - sum1;
        return summation * 1 ether / 20000;
    }

    //mint PASS 
    function checkIn(address scopeAddress, uint256 latitude ,uint256 longitude, uint256 time , bool isOrigin ) public {

        if (isOrigin) {
            //add scopeAddress to scopeMap
            scopeAddress = msg.sender;
            scopeMap[scopeAddress] = CheckInInfo(latitude, longitude, time, isOrigin,scopeAddress);
            scopeMembersMap[scopeAddress].push(msg.sender);

            //originList
            originList.push(scopeAddress);

            memberCheckList[msg.sender].push(
                CheckInInfo(latitude, longitude, time, isOrigin,scopeAddress)
            );
        }else {

            //check if 500 internal
            //add to list
            scopeMembersMap[scopeAddress].push(msg.sender);
        }

        //checklist 
        memberCheckList[msg.sender].push(
                CheckInInfo(latitude, longitude, time, isOrigin,scopeAddress)
        );

        //normal list for checked in users
        checkInList.push(
            CheckInInfo(latitude, longitude, time, isOrigin,scopeAddress)
        );
    }


    function checkDistance(uint256 lat ,uint256 long) public view returns (address) {
        for (uint i = 0; i < originList.length; i++) {
                uint latOrigin = scopeMap[originList[i]].latitude;
                uint longOrigin = scopeMap[originList[i]].longitude;
                
                uint256 distance = (latOrigin - lat) * (latOrigin - lat) + (longOrigin - long) * (longOrigin - long);
                if (distance < 500 * 500) {
                    //return the first one of 500 scope
                    return originList[i];
                }
        }
        return address(0);
    }

    function checkMembers(address scope) public view returns (uint) {
        return scopeMembersMap[scope].length;
    }

    // && scopeMembersMap[originList[i]].length >3

    //mint PASS 
    function mintPASS(address scopeAddress,uint256 amount, string memory location ) public {

        //only user who has checked in can mint
        for (uint i = 0; i < scopeMembersMap[scopeAddress].length; i++) {
            if (scopeMembersMap[scopeAddress][i] == msg.sender) {
                break;
            }
            if (i == scopeMembersMap[scopeAddress].length - 1) {
                revert("You have not checked in yet");
            }
        }

        //amount need 1 at least
        if (amount == 0) {
            revert("amount need 1 at least");
        }
        //can mint mutiple token
        for (uint i = 0; i < amount; i++) {
            //todo some conditions here like less than 5 people in a scope
            _mint(msg.sender, currentTokenID);
            //set uri in contract 

            _setTokenURI(currentTokenID, location);

            //charge points to max 
            tokenPoints[currentTokenID] = maxPoints;

            //add to scopeTokenList
            scopeTokenList[scopeAddress].push(currentTokenID);
            //increment token id
            currentTokenID++;
        }
    }


    //buy point with 10% of the price of the PASS
    function buyPoint(address scope,uint256 tokenId )  public payable {
        //check if the token is owned by the msg.sender
        if (ownerOf(tokenId) != msg.sender) {
            revert("You are not the owner of the token");
        }
        //check if the token is valid
        if (tokenPoints[tokenId] == 0) {
            revert("The token is invalid");
        }
        //check if the msg.value is enough
        if (msg.value < getPriceByLive(scope,1) / 10) {
            revert("The msg.value is not enough");
        }
        //transfer the token to the contract
    
        //charge points to max 
        tokenPoints[tokenId] = maxPoints;
    }

}




