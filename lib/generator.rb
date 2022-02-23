# Generatoes bdd test file from test cases hash
module Generator
  def self.test_case_tag(event, test_case)
    if event == test_case.last
      "Then"
    elsif event == test_case.first
      "When"
    else
      "And"
    end
  end

  def self.bdd_from_test_cases(test_cases_hash, feature_name = "Test")
    File.open "output/#{feature_name}.feature", "w" do |file|
      file.write("Feature: #{feature_name}\n")
      test_cases_hash.each_with_index do |test_case, index|
        file.write("\tScenario: #{index}\n")
        test_case.each do |event|
          file.write("\t\t#{test_case_tag(event, test_case)} #{event.to_s}\n")
        end
      end
    end
  end
end