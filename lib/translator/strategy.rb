# frozen_string_literal: true

class Translator::Strategy
  def bdd_from_hash(_test_cases_hash, _feature_name = 'Test')
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
