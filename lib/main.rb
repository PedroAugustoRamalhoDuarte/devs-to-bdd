# frozen_string_literal: true

require 'bundler/setup'
require 'dry/cli'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module DevsToBDD
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc 'Print version'

        def call(*)
          puts '0.1'
        end
      end

      class GenerateFromSes < Dry::CLI::Command
        desc 'Generate features bdd files from ses'

        argument :ses_file_path, required: true, desc: '.ses file path'
        argument :output_file_name, desc: 'output file name'

        def call(ses_file_path:, output_file_name: 'output', **)
          output_path = Generator.bdd_from_ses(ses_file_path, output_file_name)
          puts "File created in #{output_path}"
        end
      end

      class GenerateFromDnl < Dry::CLI::Command
        desc 'Generate features bdd files from dnl'

        argument :dnl_file_path, required: true, desc: '.dnl file path'
        argument :output_file_name, desc: 'output file name'

        def call(dnl_file_path:, output_file_name: 'output', **)
          output_path = Generator.bdd_from_dnl(dnl_file_path, output_file_name)
          puts "File created in #{output_path}"
        end
      end

      register 'version', Version, aliases: %w[v -v --version]
      register 'ses-generator', GenerateFromSes
      register 'dnl-generator', GenerateFromDnl
    end
  end
end

Dry::CLI.new(DevsToBDD::CLI::Commands).call
