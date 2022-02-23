require_relative 'generator'
require_relative 'parse/main'
require_relative 'parse/ses'

Generator.bdd_from_test_cases(Parse::Ses.test_cases_hash("BankTellerExample"), "BankTeller")