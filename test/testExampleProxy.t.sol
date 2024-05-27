// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {exampleProxy, exampleLogic} from "../src/exampleERC1967.sol";

contract StorageCollisionTest is Test {
    exampleLogic public logic;
    exampleProxy public proxy;
    exampleLogic public proxiedLogic;

    function setUp() public {
        logic = new exampleLogic();
        proxy = new exampleProxy(address(logic), "");
        proxiedLogic = exampleLogic(address(proxy));
    }

    function testStorageCollision() public {
        proxiedLogic.setValue(42);

        assertEq(proxiedLogic.value(), 42);

        proxy.proxyValue(); 
        
        assertEq(proxiedLogic.value(), 42, "[!] There is no storage collision");
    }
}

