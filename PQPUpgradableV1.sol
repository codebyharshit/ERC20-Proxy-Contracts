// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC20Upgradeable.sol";
import "./ERC20BurnableUpgradeable.sol";
import "./PausableUpgradeable.sol";
import "./OwnableUpgradeable.sol";
import "./Initializable.sol";
import "./UUPSUpgradeable.sol";

/**
 * @title PQP Token Contract
 * @dev This contract implements the PQP token functionality.
 */
contract PQPUpgradableV1 is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    uint256 public mintingFee; // Fee applied when minting new tokens
    uint256 private _totalSupply; // Total supply of PQP tokens

    /**
     * @dev Initializes the PQP token contract.
     * @param _mintingFee The fee applied when minting new tokens.
     */
    function initialize(uint256 _mintingFee) public initializer {
        __ERC20_init("Planet Q Productions", "PQP");
        __ERC20Burnable_init();
        __Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();

        mintingFee = _mintingFee;
        _totalSupply = 1000000000000000000000000;
    }

    /**
     * @dev Pauses all token transfers.
     * Requirements:
     * - The caller must be the contract owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses token transfers.
     * Requirements:
     * - The caller must be the contract owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Returns the total supply of PQP tokens.
     * @return The total supply of PQP tokens.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Sets the minting fee for new tokens.
     * Requirements:
     * - The caller must be the contract owner.
     * @param _mintingFee The new minting fee value.
     */
    function setMintingFee(uint256 _mintingFee) public onlyOwner {
        mintingFee = _mintingFee;
    }

    /**
     * @dev Mints new PQP tokens and assigns them to the specified address.
     * Requirements:
     * - The caller must send enough Ether to cover the minting fee.
     * @param to The address to which the new tokens will be minted.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) public payable {
        uint256 totalFee = (amount / 10 ** 18) * mintingFee;
        require(msg.value >= totalFee, "Insufficient fee");
        _mint(to, amount);
    }

    /**
     * @dev Hook function that is called before each token transfer.
     * @param from The address transferring the tokens.
     * @param to The address receiving the tokens.
     * @param amount The amount of tokens being transferred.
     * Requirements:
     * - Token transfers must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Burns a specified amount of PQP tokens from the caller's balance.
     * Requirements:
     * - The caller must have a sufficient balance to burn the requested amount.
     * @param amount The amount of tokens to burn.
     */
    function burn(uint256 amount) public virtual override {
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");
        _burn(_msgSender(), amount);
        _totalSupply -= amount;
    }

    /**
     * @dev Authorizes the upgrade to a new contract implementation.
     * Requirements:
     * - The caller must be the contract owner.
     * @param newImplementation The address of the new contract implementation.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
