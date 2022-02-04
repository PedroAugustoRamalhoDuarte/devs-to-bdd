# Desired output
Feature: BankTellerExample

  Scenario: Customer send Hello
    When Customer send Hello to BankTeller
    Then BankTeller send Hi to Customer

  Scenario: Customer send RequestWithdrawal
    When Customer send Hello to BankTeller
    Then BankTeller send Withdrawal to Customer