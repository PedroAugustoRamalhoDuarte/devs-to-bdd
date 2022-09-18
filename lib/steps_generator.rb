# frozen_string_literal: true

# Class to generate step definitions for a cucumber file
class StepsGenerator
  # @param input [String] input file string
  # @param output [String] output file string
  def call(input, output = 'output/step_definitions/steps.rb')
    s = `cucumber #{input} --publish-quiet -d`
    f = File.open(output, 'w')
    f.puts(s.scan(/(?<=snippets:).*/m))
    f.close
  end
end
