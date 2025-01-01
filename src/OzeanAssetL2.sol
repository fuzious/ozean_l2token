// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/interfaces/IERC165.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @notice Minimal interface required by the Optimism L2 bridge to
 *         correctly mint and burn tokens during cross-chain transfers.
 */
interface IOptimismMintableERC20 is IERC165 {
    function remoteToken() external view returns (address);
    function bridge() external returns (address);
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

/**
 * @title MyTokenL2
 * @notice ERC20 token on L2 that the L2 bridge can mint/burn.
 *         Conforms to the IOptimismMintableERC20 interface you provided.
 */
contract OzeanAssetL2 is ERC20, IOptimismMintableERC20 {
    /**
     * @dev The designated L2 bridge (e.g. L2StandardBridge) allowed
     *      to call mint() and burn().
     */
    address private _bridge;

    /**
     * @dev The corresponding L1 token address (a.k.a. remoteToken).
     */
    address private _remoteToken;

    /**
     * @param bridge_      Address of the L2 bridge on OP Sepolia
     * @param remoteToken_ Address of the corresponding L1 token (on Sepolia)
     * @param _name        ERC20 name
     * @param _symbol      ERC20 symbol
     */
    constructor(
        address bridge_,
        address remoteToken_,
        string memory _name,
        string memory _symbol
    )
        ERC20(_name, _symbol)
    {
        _bridge = bridge_;
        _remoteToken = remoteToken_;
    }

    /**
     * @notice Required by IERC165. Returns true if this contract implements the given interfaceId.
     */
    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return
            interfaceId == type(IOptimismMintableERC20).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @notice The L1 token address that corresponds to this L2 token.
     */
    function remoteToken() external view override returns (address) {
        return _remoteToken;
    }

    /**
     * @notice The L2 bridge address that is allowed to call mint/burn.
     *         (Interface does not specify `view`, so we match exactly.)
     */
    function bridge() external override returns (address) {
        return _bridge;
    }

    /**
     * @notice Mints new tokens. Only the L2 bridge can call this.
     */
    function mint(address _to, uint256 _amount) external override {
        require(msg.sender == _bridge, "MyTokenL2: caller is not the L2 bridge");
        _mint(_to, _amount);
    }

    /**
     * @notice Burns tokens. Only the L2 bridge can call this.
     */
    function burn(address _from, uint256 _amount) external override {
        require(msg.sender == _bridge, "MyTokenL2: caller is not the L2 bridge");
        _burn(_from, _amount);
    }
}
