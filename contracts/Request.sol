// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC20.sol";

struct Request {
    IERC721 collection;
    uint256 tokenId;
    IERC20 token;
    uint256 amount;
    address creator;
    bool active;
}