from brownie import network, config, accounts, MockV3Aggregator
from web3 import Web3

DECIMALS = 8
STARTING_PRICE = 300000000000


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def deploy_mocks():
     #Mocks simula ser nodo de chainlink
    print(f"Active network es {network.show_active()}")
    print(f"Deploy the mocks")
        
    # MockV3Aggregator.deploy(8, Web3.toWei(2000, "ether"), {"from": get_account()})
    MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE,{"from": get_account()})
        
    print(f"Mocks agregator")
