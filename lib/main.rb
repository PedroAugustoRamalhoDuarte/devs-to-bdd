require_relative 'generator'
require_relative 'parse/main'
require_relative 'parse/ses'
require_relative 'parse/dnl'

Generator::bdd_from_dnl("BankTellerExample", "BankTeller", "BankTellerDNL")
Generator::bdd_from_dnl("BankTellerExample", "BankVault", "BankVaultDNL")
Generator::bdd_from_dnl("BankTellerExample", "Customer", "CustomerDNL")
