// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "contracts/interfaces/IBribeFactory.sol";
import 'contracts/InternalBribe.sol';
import 'contracts/ExternalBribe.sol';

// 0xA84EA94Aa705F7d009CDDF2a60f65c0d446b748E
contract BribeFactory is IBribeFactory {
    address public last_internal_bribe;
    address public last_external_bribe;

    function createInternalBribe(address[] memory allowedRewards) external returns (address) {
        last_internal_bribe = address(new InternalBribe(msg.sender, allowedRewards));
        return last_internal_bribe;
    }

    function createExternalBribe(address[] memory allowedRewards) external returns (address) {
        last_external_bribe = address(new ExternalBribe(msg.sender, allowedRewards));
        return last_external_bribe;
    }
}