// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract exampleProxy is ERC1967Proxy {
    uint256 public proxyValue;

    constructor(address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {}
}


contract exampleLogic {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}