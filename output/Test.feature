Feature: Test
	Scenario: 0
		When Customer send Hello to BankTeller
		Then BankTeller send Hi to Customer
	Scenario: 1
		When Customer send RequestWithdrawal to BankTeller
		And BankTeller send RetrieveMoney to BankVault
		And BankVault send Money to BankTeller
		Then BankTeller send Withdrawal to Customer
