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

      # Command for generate bdd from ses
      class GenerateFromSes < Dry::CLI::Command
        desc 'Generate features bdd files from ses'

        argument :ses_file_path, required: true, desc: '.ses file path'
        argument :output_file_name, desc: 'output file name'

        def call(ses_file_path:, output_file_name: 'output', **)
          generator = Generator.new(Parse::Ses.new, Translator::Ses.new)
          puts "File created in #{generator.generate_bdd_file(ses_file_path, output_file_name)}"
        end
      end

      # Command for generate bdd from dnl
      class GenerateFromDnl < Dry::CLI::Command
        desc 'Generate features bdd files from dnl'

        argument :dnl_file_path, required: true, desc: '.dnl file path'
        argument :output_file_name, desc: 'output file name'

        def call(dnl_file_path:, output_file_name: 'output', **)
          generator = Generator.new(Parse::Dnl.new, Translator::Dnl.new)
          puts "File created in #{generator.generate_bdd_file(dnl_file_path, output_file_name)}"
        end
      end

      # Command for generate bdd from multiple dnl files
      class BulkGenerateFromDnl < Dry::CLI::Command
        desc 'Generate all bdd features from dnl inside ms4 project'

        argument :project_file_path, required: true, desc: 'project file path'

        def call(project_file_path:, **)
          parser = Parse::Dnl.new
          translator = Translator::Dnl.new
          generator = Generator.new(parser, translator)
          Dir["#{project_file_path}/dnl/**/*.dnl"].each do |dnl_file_path|
            output_file_name = dnl_file_path.split('/')[-1][..-5]
            puts "File created in #{generator.generate_bdd_file(dnl_file_path, output_file_name)}"
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
