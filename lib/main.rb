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
          puts '0.2'
        end
      end

      class GenerateFromSes < Dry::CLI::Command
        desc 'Generate features bdd files from ses'

        argument :ses_file_path, required: true, desc: '.ses file path'
        argument :output_file_name, desc: 'output file name'

        def call(ses_file_path:, output_file_name: 'output', **)
          test_case_hash = Parse::Ses.new.test_cases_hash(ses_file_path)
          output_path = Translator::Ses.new.bdd_from_ses(test_case_hash, output_file_name)
          puts "File created in #{output_path}"
        end
      end

      class GenerateFromDnl < Dry::CLI::Command
        desc 'Generate features bdd files from dnl'

        argument :dnl_file_path, required: true, desc: '.dnl file path'
        argument :output_file_name, desc: 'output file name'

        def call(dnl_file_path:, output_file_name: 'output', **)
          test_case_hash = Parse::Dnl.new.test_cases_hash(dnl_file_path)
          output_path = Translator::Dnl.new.bdd_from_dnl(test_case_hash, output_file_name)
          puts "File created in #{output_path}"
        end
      end

      class BulkGenerateFromDnl < Dry::CLI::Command
        desc 'Generate all bdd features from dnl inside ms4 project'

        argument :project_file_path, required: true, desc: 'project file path'

        def call(project_file_path:, **)
          parser = Parser::Dnl.new
          translator = Translator::Dnl.new
          Dir["#{project_file_path}/dnl/**/*.dnl"].each do |dnl_file_path|
            output_file_name = dnl_file_path.split('/')[-1][..-5]
            output_path = translator.bdd_from_dnl(parser.test_cases_hash(dnl_file_path),
                                                  output_file_name)
            puts "File created in #{output_path}"
          end
        end
      end

      register 'version', Version, aliases: %w[v -v --version]
      register 'ses-generator', GenerateFromSes
      register 'dnl-generator', GenerateFromDnl
      register 'dnl-bulk-generator', BulkGenerateFromDnl
    end
  end
end

Dry::CLI.new(DevsToBDD::CLI::Commands).call
