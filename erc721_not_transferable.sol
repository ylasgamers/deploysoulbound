// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Not transferable erc721
// Set name nft contract
contract NAMENFT_ERC721 {
    string public name = "EXAMPLE_NFT"; // Set name nft
    string public symbol = "ENFT"; // Set symbol nft

    address public owner;
    uint256 private _tokenIdCounter;
    string private baseTokenURI;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    // ERC165 interface IDs
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor(string memory baseURI_) {
        owner = msg.sender;
        baseTokenURI = baseURI_;
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == _INTERFACE_ID_ERC165 ||
            interfaceId == _INTERFACE_ID_ERC721 ||
            interfaceId == _INTERFACE_ID_ERC721_METADATA;
    }

    function mint(address to) external onlyOwner {
        require(to != address(0), "Invalid address");

        uint256 tokenId = ++_tokenIdCounter;
        _owners[tokenId] = to;
        _balances[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "Invalid address");
        return _balances[account];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return string(abi.encodePacked(baseTokenURI, uint2str(tokenId)));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }

    // Disabled transfer & approval functions
    function transferFrom(address, address, uint256) public pure {
        revert("Transfers disabled");
    }

    function safeTransferFrom(address, address, uint256) public pure {
        revert("Transfers disabled");
    }

    function safeTransferFrom(address, address, uint256, bytes memory) public pure {
        revert("Transfers disabled");
    }

    function approve(address, uint256) public pure {
        revert("Approvals disabled");
    }

    function setApprovalForAll(address, bool) public pure {
        revert("Approvals disabled");
    }

    function getApproved(uint256) public pure returns (address) {
        return address(0);
    }

    function isApprovedForAll(address, address) public pure returns (bool) {
        return false;
    }

    // Required ERC-721 event
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
}