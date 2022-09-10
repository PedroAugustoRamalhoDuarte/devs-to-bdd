# frozen_string_literal: true

# Strategy abstract class to parse files
class Parse::Strategy
  # Returns test cases hash from file_path
  #
  # @abstract
  # @return [Hash]
  def test_cases_hash(file_path)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
