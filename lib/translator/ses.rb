# frozen_string_literal: true

class Translator::Ses
  # Creates feature files from ses file
  #
  # @return [String] Output path
  def bdd_from_ses(test_cases_hash, feature_name = 'Test')
    output_path = File.join(Generator::OUTPUT_DIR, "#{feature_name}.feature")

    File.open output_path, 'w' do |file|
      file.write("Feature: #{feature_name}\n")
      test_cases_hash.each_with_index do |test_case, index|
        file.write("\tScenario: #{index}\n")
        test_case.each do |event|
          file.write("\t\t#{test_case_tag(event, test_case)} #{event}\n")
        end
      end
    end

    output_path
  end

  private

  def test_case_tag(event, test_case)
    if event == test_case.last
      'Then'
    elsif event == test_case.first
      'When'
    else
      'And'
    end
  end
end
