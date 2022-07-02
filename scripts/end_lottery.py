from scripts.helpful_scripts import fund_with_link, get_account
from brownie import lottery, config, network, accounts
import time


def end_lottery():
    tx = fund_with_link(lottery[-1].address)
    tx.wait(1)
    bal = lottery[-1].balance()
    tx = lottery[-1].end_lottery({"from": get_account()})
    tx.wait(1)
    time.sleep(60)
    print(f"{lottery[-1].winner()} won {bal} Gwei")


def main():
    end_lottery()
