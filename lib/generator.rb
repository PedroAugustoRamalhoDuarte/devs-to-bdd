# frozen_string_literal: true

# Context to generate bdd files choseing parse and translator strategy
class Generator
  attr_writer :parser, :translator

  def initialize(parser, translator)
    @parser = parser
    @translator = translator
  end

  # Creates feature files from file path using strategy above
  # @param [String] file_path
  # @param [String] output_name
  #
  # @return [String] Output path
  def generate_bdd_file(file_path, output_name)
    test_case_hash = @parser.test_cases_hash(file_path)
    @translator.bdd_from_hash(test_case_hash, output_name)
  end
end
