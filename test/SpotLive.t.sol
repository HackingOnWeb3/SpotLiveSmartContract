// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {SpotLive} from "../src/SpotLive.sol";

contract SpotLiveTest is Test {
    SpotLive public spotlive;

    function setUp() public {
        spotlive = new SpotLive();
        // spotlive.setNumber(0);
    }

    // function test_checkIn() public {
    //     address scope = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
    //     spotlive.checkIn(scope,1, 2, 3,true);

    //     (uint256 test1,uint256 test2,uint256 test3,bool test4, address belongsto) =  spotlive.scopeMap(scope);
        
    //     // console2.log(spotlive.scopeMap[scope]);
    //     assertEq(test1, 1);
    //     assertEq(test2, 2);
    //     assertEq(test3, 3);
    //     assertEq(test4, true);
    //     assertEq(belongsto, 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    // }

    // function test_checkDistance

    // function test_getDistance() public {
    //     address scope = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
    //     spotlive.checkIn(scope,1, 2, 3,true);

    //     (uint256 test1,uint256 test2,uint256 test3,bool test4, address belongsto) =  spotlive.scopeMap(scope);
        
    //     // console2.log(spotlive.scopeMap[scope]);
    //     assertEq(test1, 1);
    //     assertEq(test2, 2);
    //     assertEq(test3, 3);
    //     assertEq(test4, true);
    //     assertEq(belongsto, 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    // }


    function test_getCheckInList() public {

        spotlive.checkIn(msg.sender,1, 2, 3,true);

        console2.log(msg.sender);
        SpotLive.CheckInInfo[] memory test = spotlive.getCheckInList(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
        
        console2.log("=========");
        console2.log(test.length);
    }

    // function test_checkedin() public {

    // spotlive.checkIn(
    //         0x8F8313aEE5aE1c46110A3880f98520D4C300207F, 
    //         22542859, 
    //         114059560, 
    //         1697357848858, 
    //         true);
    // }
}
