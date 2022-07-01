from brownie import lottery, config, network
from scripts.helpful_scripts import get_account


def buy_ticket():
    tx = lottery[-1].buy_ticket(
        {
            "from": get_account(),
            "value": lottery[-1].ticket_price()
            * 10**18
            / (lottery[-1].get_eth_price() / 10**18),
        }
    )
    tx.wait(1)


def main():
    buy_ticket()
