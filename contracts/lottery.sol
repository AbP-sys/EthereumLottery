// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract lottery is VRFConsumerBase, Ownable {
    enum state {
        OPEN,
        CLOSE
    }
    uint256 public ticket_price = 20;
    state current_state = state.CLOSE;
    address payable[] players;
    address payable public winner;
    address AV3Interface;
    bytes32 keyHash;
    uint256 fee;

    constructor(
        address _AV3Interface,
        address _vrfCoordinator,
        address _link,
        bytes32 _keyHash,
        uint256 _fee
    ) public VRFConsumerBase(_vrfCoordinator, _link) {
        AV3Interface = _AV3Interface;
        keyHash = _keyHash;
        fee = _fee;
    }

    function start_lottery() public onlyOwner {
        require(current_state == state.CLOSE, "Lottery already running");
        current_state = state.OPEN;
    }

    function get_ticket_price() public view returns (string memory) {
        uint256 ETHtoUSD = get_eth_price() / 10**18;
        string memory ans = string.concat(
            Strings.toString(ticket_price),
            " USD | "
        );
        string memory ans1 = string.concat(
            Strings.toString((10**9 * ticket_price) / ETHtoUSD),
            " Gwei"
        );
        return string.concat(ans, ans1);
    }

    function get_eth_price() public view returns (uint256) {
        //eth to USD
        AggregatorV3Interface priceFeed = AggregatorV3Interface(AV3Interface);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    function buy_ticket() public payable {
        require(
            current_state == state.OPEN,
            "Sorry, no running lottery. Please come back later"
        );
        require(
            ((msg.value * get_eth_price()) / 10**18) >= ticket_price * 10**18,
            "Cannot buy ticket"
        );
        players.push(payable(msg.sender));
    }

    function end_lottery() public onlyOwner {
        require(
            current_state == state.OPEN,
            "Sorry, no running lottery. Please come back later"
        );
        requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        winner = players[randomness % players.length];
        winner.transfer(address(this).balance);
        players = new address payable[](0);
        current_state = state.CLOSE;
    }
}
