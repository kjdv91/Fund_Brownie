import imp

from brownie import accounts, network, config
from scripts.helpfull_script import get_account
from scripts.deploy import deploy_fund_me


def test_can_withdraw():
   
    account = get_account()
    fund_me = deploy_fund_me()
    entrance_fee = fund_me.getEntrance() +100
    tx = fund_me.fund({"from": account, "value": entrance_fee})
    tx.wait(1)

    assert fund_me.addressToAmountfunded(account.address)  == entrance_fee

    tx2 = fund_me.withdraw({"from": account})
    tx2.wait(1)

    assert fund_me.addressToAmountfunded(account.address)  == 0
