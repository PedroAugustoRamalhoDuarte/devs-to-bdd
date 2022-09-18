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
        desc 'Generate bdd feature file from ms4 .ses file'

        argument :ses_file_path, required: true, desc: '.ses file path'
        argument :output_file_name, desc: 'output file name'
        option :steps, default: 'false', values: %w[true false], desc: 'Generate step definitions'

        def call(ses_file_path:, output_file_name: 'output', **options)
          generator = Generator.new(Parse::Ses.new, Translator::Ses.new)
          file = generator.generate_bdd_file(ses_file_path, output_file_name)
          puts "File created in #{file}"

          StepDefinitions.new.call(file_path: file) if options[:steps]
        end
      end

      # Command for generate bdd from dnl
      class GenerateFromDnl < Dry::CLI::Command
        desc 'Generate bdd feature file from ms4 .dnl file'

        argument :dnl_file_path, required: true, desc: '.dnl file path'
        argument :output_file_name, desc: 'output file name'
        option :steps, default: 'false', values: %w[true false], desc: 'Generate step definitions'

        def call(dnl_file_path:, output_file_name: 'output', **)
          generator = Generator.new(Parse::Dnl.new, Translator::Dnl.new)
          file = generator.generate_bdd_file(dnl_file_path, output_file_name)
          puts "File created in #{file}"

          StepDefinitions.new.call(file_path: file) if options[:steps]
        end
      end

      # Command for generate bdd from multiple dnl files
      class BulkGenerateFromDnl < Dry::CLI::Command
        desc 'Generate all bdd features from dnl folder inside ms4 project'

        argument :project_file_path, required: true, desc: 'project file path'
        option :steps, default: 'false', values: %w[true false], desc: 'Generate step definitions'

        def call(project_file_path:, **options)
          parser = Parse::Dnl.new
          translator = Translator::Dnl.new
          generator = Generator.new(parser, translator)
          Dir["#{project_file_path}/dnl/**/*.dnl"].each do |dnl_file_path|
            output_file_name = dnl_file_path.split('/')[-1][..-5]
            output_path = generator.generate_bdd_file(dnl_file_path, output_file_name)
            puts "File created in #{output_path}"

            if options[:steps]
              step_output_path = File.join("#{Translator::OUTPUT_DIR}/step_definitions", "#{output_file_name}.rb")
              StepDefinitions.new.call(file_path: output_path, output_file_path: step_output_path)
            end
          end
        end
      end

      class StepDefinitions < Dry::CLI::Command
        desc 'Generate step definitions from a feature file'

        argument :file_path, required: true, desc: '.feature file path'
        argument :output_file_path, desc: 'output file path'

        def call(file_path:, output_file_path: 'output/step_definitions/steps.rb', **)
          StepsGenerator.new.call(file_path, output_file_path)
          puts "File created in #{output_file_path}"
        end
      end

      register 'version', Version, aliases: %w[v -v --version]
      register 'ses-generator', GenerateFromSes, aliases: %w[ses]
      register 'dnl-generator', GenerateFromDnl, aliases: %w[dnl]
      register 'dnl-bulk-generator', BulkGenerateFromDnl, aliases: %w[dnl-bulk]
      register 'steps-definition', StepDefinitions, aliases: %w[steps]
    end
  end
end

Dry::CLI.new(DevsToBDD::CLI::Commands).call
