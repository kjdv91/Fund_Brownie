from brownie import FundMe, config, network, accounts
from scripts.helpfull_script import get_account, deploy_mocks


def fund():
    price_feed_address = config["networks"][network][network.show_active()]["eth_usd_price_feed"]
    account = get_account()
    fund_me = FundMe.deploy(price_feed_address, {"from": account} )
    entrance_fee = fund_me.getEntranceFee()
    
    print(entrance_fee)
    print("funding")
    fund_me.fund({"from": account, "value": entrance_fee})

def withdraw():
    price_feed_address = config["networks"][network][network.show_active()]["eth_usd_price_feed"]
    fund_me = FundMe.deploy(price_feed_address, {"from": account} )
    account = get_account()
    print("withdrawing")
    fund_me.withdraw({"from": account})

def main():
    fund()
    withdraw()