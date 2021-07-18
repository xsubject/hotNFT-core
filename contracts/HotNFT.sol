// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC20.sol";
import "./Request.sol";
import "./IWBNB.sol";

contract HotNFT {
  Request[] public requests;
  IWBNB public WBNB;

  constructor(address wbnb) {
    WBNB = IWBNB(wbnb);
  }

  function request(uint index) public view returns (Request memory) {
    require(index < requests.length, "HotNFT: INVALID_INDEX");
    return requests[index];
  }

  function addRequest(address collection, uint256 tokenId, address token, uint256 amount) public {
    Request memory req = Request(
      IERC721(collection),
      tokenId,
      IERC20(token),
      amount,
      msg.sender,
      true
    );
    req.collection.safeTransferFrom(msg.sender, address(this), tokenId);
    requests.push(req);
  }

  function executeRequest(uint256 requestId) public {
    _executeRequest(msg.sender, requestId);
  }

  function _executeRequest(address from, uint256 requestId) private {
    require(requests[requestId].active, "HotNFT: NOT_ACTIVE_REQUEST");

    _getToken(from, requestId);
    _deliverToken(requests[requestId].creator, requestId);
    _deliverNFT(from, requestId);
    requests[requestId].active = false;
  }

  function cancelRequest(uint256 requestId) public {
    require(requests[requestId].active, "HotNFT: NOT_ACTIVE_REQUEST");
    require(requests[requestId].creator == msg.sender, "HotNFT: CALLER_NOT_CREATOR");
    
    _deliverNFT(msg.sender, requestId);
    requests[requestId].active = false;
  }

  function _getToken(address from, uint256 requestId) private {
    requests[requestId].token.transferFrom(from, address(this), requests[requestId].amount);
  }

  function _deliverToken(address to, uint256 requestId) private {
    requests[requestId].token.transferFrom(address(this), to, requests[requestId].amount);
  }

  function _deliverNFT(address to, uint256 requestId) private {
    requests[requestId].collection.transferFrom(address(this), to, requests[requestId].tokenId); 
  }
}
