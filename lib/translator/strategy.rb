# frozen_string_literal: true

# Strategy abstract class to translate files
class Translator::Strategy
  # Creates feature files from hash
  # @abstract
  #
  # @return [String] Output path
  def bdd_from_hash(_test_cases_hash, _feature_name = 'Test')
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
