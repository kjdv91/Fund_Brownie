from brownie import FundMe, MockV3Aggregator, config, network
from scripts.helpfull_script import deploy_mocks, get_account
from web3 import Web3


def deploy_fund_me():
    if network.show_active() != "development":
        price_feed_address = config["networks"][network][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address 
       


    account = get_account()
    fund_me = FundMe.deploy(price_feed_address, {"from": account}, 
    publish_source=config["networks"][network.show_active()].get("verify"),)
    print(f"El contrato deployado es {fund_me }")

def main():
    deploy_fund_me()