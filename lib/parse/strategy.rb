# frozen_string_literal: true

class Parse::Strategy
  def test_cases_hash(file_path)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
