require_relative 'generator'
require_relative 'parse/main'
require_relative 'parse/ses'
require_relative 'parse/dnl'

# Generator.bdd_from_test_cases(Parse::Ses.test_cases_hash("BankTellerExample"), "BankTeller")
#
#
Generator::bdd_from_dnl("BankTellerExample", "BankTeller")
