from scripts.helpful_scripts import get_account, get_contract
from brownie import lottery, config, network
from scripts.buy_ticket import buy_ticket
from scripts.end_lottery import end_lottery


def deploy_lottery():
    account = get_account()
    tx = lottery.deploy(
        get_contract("eth_usd_price_feed").address,
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["keyhash"],
        config["networks"][network.show_active()]["fee"],
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )


def start_lottery():
    tx = lottery[-1].start_lottery({"from": get_account()})
    tx.wait(1)


def get_price():
    price = lottery[-1].get_ticket_price()
    print(price)


def main():
    deploy_lottery()
    # start_lottery()
    # get_price()
    # buy_ticket()
