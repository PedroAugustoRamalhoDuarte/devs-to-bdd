Feature: Customer
  Scenario: hold in sendHello
    When holding in sendHello for time 1
    Then sends Hello
    And go to waitforHi
  Scenario: waitforHi
    When in waitforHi and receive Hi go to sendRequestWithdrawal
    And hold in sendRequestWithdrawal for time 1
    Then sends RequestWithdrawal
    And go to waitforWithdrawal
  Scenario: waitforWithdrawal
    When in waitforWithdrawal and receive Withdrawal go to passive
