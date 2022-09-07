# frozen_string_literal: true

# Module for generates bdd test file from ms4 files
module Generator
  OUTPUT_DIR = File.join(File.dirname(__FILE__), '../output/')

  # Returns cucumber keyword based onde event order
  #
  # @return [String]
  def self.test_case_tag(event, test_case)
    if event == test_case.last
      'Then'
    elsif event == test_case.first
      'When'
    else
      'And'
    end
  end

  # Creates feature files from ses file
  #
  # @return [String] Output path
  def self.bdd_from_ses(ses_file_path, feature_name = 'Test')
    test_cases_hash = Parse::Ses.test_cases_hash(ses_file_path)

    output_path = File.join(OUTPUT_DIR, "#{feature_name}.feature")

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

  # Convert a dnl line to a cucumber instruction
  #
  # @return [String]
  def self.convert_dnl_line(line)
    if line.include? 'output'
      "Then sends #{line.split[-1]}"
    elsif line.include? 'from'
      "And go to #{line.split[-1]}"
    elsif line.include?('to start') && line.include?('hold')
      "When holding #{line.split(',')[1][6..]}"
    elsif line.include? 'hold'
      "And #{line}"
    elsif line.include? 'passivate'
      # pass
    elsif !line.empty?
      line[0].upcase + line[1..]
    end
  end

  # Creates feature files from dnl file
  #
  # @return [String] Output path
  def self.bdd_from_dnl(file_path, feature_name = 'Test')
    test_cases_hash = Parse::Dnl.test_cases_hash(file_path)
    output_path = File.join(OUTPUT_DIR, "#{feature_name}.feature")

    File.open output_path, 'w' do |file|
      file.write("Feature: #{feature_name}\n")
      test_cases_hash.each do |test_case|
        file.write("\tScenario: #{test_case[0]}\n")
        test_case[1].each do |line|
          dnl_line = convert_dnl_line(line)
          file.write("\t\t#{dnl_line}\n") if dnl_line
        end
      end
    end

    output_path
  end
end
