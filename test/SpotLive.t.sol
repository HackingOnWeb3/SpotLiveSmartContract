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

    function test_checkIn() public {
        address scope = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
        spotlive.checkIn(scope,1, 2, 3,true);

        (uint256 test1,uint256 test2,uint256 test3,bool test4, address belongsto) =  spotlive.scopeMap(scope);
        
        // console2.log(spotlive.scopeMap[scope]);
        assertEq(test1, 1);
        assertEq(test2, 2);
        assertEq(test3, 3);
        assertEq(test4, true);
        assertEq(belongsto, 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    }

    // function test_Increment() public {
    //     spotlive.increment();
    //     assertEq(spotlive.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     spotlive.setNumber(x);
    //     assertEq(spotlive.number(), x);
    // }
}
