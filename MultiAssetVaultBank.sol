// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

// @notice Bóveda bancaria intermedia con soporte para ETH, tokens ERC20, transferencias internas y funciones de seguridad.

contract MultiAssetVaultBank {

    //Variable
    using SafeERC20 for IERC20;
    //Address admin
    address public admin;
    //User Balance
    mapping (address=>mapping (address=>uint256))public balances;

    //Events
    event EtherDeposited(address indexed user, uint256 amount);
    event EtherWithdraw(address indexed user, uint256 amount);
    event TokenDeposited(address indexed user, address indexed token, uint256 amount);
    event TokenWithdrawn(address indexed user, address indexed token, uint256 amount);
    event InternalTransfer(address indexed from, address indexed to, address indexed token, uint256 amount);
    /// @notice Evento de recuperación de fondos no rastreados
    event UntrackedFundsRecovered(address indexed to, uint256 amount);

    /// @notice Evento de pausa
    event Paused(address indexed by);

    /// @notice Evento de reanudación
    event Unpaused(address indexed by);

    //Modifier only for admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // Constructors
    constructor(address admin_) {
        require(admin_ != address(0), "Admin cannot be zero address");
        admin = admin_;
    }

    //Functions
    function depositEth() external payable {
        require(msg.value>0,"Must send ETH");
        balances[msg.sender][address(0)]+=msg.value;
        emit EtherDeposited(msg.sender,msg.value);
    }
    function withdrawEth(uint256 amount) external  {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender][address(0)] >= amount, "Insufficient ETH balance");

        balances[msg.sender][address(0)] -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");

        emit EtherWithdraw(msg.sender, amount);
    }
     function depositToken(address token, uint256 amount) external{
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be > 0");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender][token] += amount;

        emit TokenDeposited(msg.sender, token, amount);
    }
    function withdrawToken(address token, uint256 amount) external  {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender][token] >= amount, "Insufficient token balance");

        balances[msg.sender][token] -= amount;
        IERC20(token).safeTransfer(msg.sender, amount);

        emit TokenWithdrawn(msg.sender, token, amount);
    }
    function transferInternal(address to, uint256 amount) external  {
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender][address(0)] >= amount, "Insufficient ETH balance");

        balances[msg.sender][address(0)] -= amount;
        balances[to][address(0)] += amount;

        emit InternalTransfer(msg.sender, to, address(0), amount);
    }
    //ecupera ETH no rastreado enviado por accidente @dev Solo puede ser llamado por el admin
    function recoverUntrackedFunds() external onlyAdmin {
        uint256 recoverable = address(this).balance;
        payable(admin).transfer(recoverable);
        emit UntrackedFundsRecovered(admin, recoverable);
    }
    // @notice Pausa operaciones críticas del contrato
    

    /// @dev Previene depósitos accidentales sin usar depositEth()
    receive() external payable {
        revert("Use depositEth()");
    }

    fallback() external payable {
        revert("Invalid call");
    }







    


}

