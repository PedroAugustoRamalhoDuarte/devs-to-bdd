require "bundler/setup"
require "dry/cli"
require_relative 'generator'
require_relative 'parse/main'
require_relative 'parse/ses'
require_relative 'parse/dnl'

module DevsToBDD
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts "0.1"
        end
      end

      class GenerateFromSes < Dry::CLI::Command
        desc "Generate features files for bdd"

        argument :ses_file_path, required: true, desc: ".ses file path"
        argument :output_file_name, desc: "output file name"

        def call(ses_file_path:, output_file_name: 'output', **)
          output_path = Generator::bdd_from_ses(ses_file_path, output_file_name)
          puts "File created in #{output_path}"
        end
      end

      register "version", Version, aliases: %w[v -v --version]
      register "gen-generator", GenerateFromSes
    end
  end
end

Dry::CLI.new(DevsToBDD::CLI::Commands).call
# Generator::bdd_from_dnl("BankTellerExample", "BankTeller", "BankTellerDNL")
# Generator::bdd_from_dnl("BankTellerExample", "BankVault", "BankVaultDNL")
# Generator::bdd_from_dnl("BankTellerExample", "Customer", "CustomerDNL")
