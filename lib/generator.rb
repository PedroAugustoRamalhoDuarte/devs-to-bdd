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

  def self.bdd_from_ses(example_name, feature_name = "Test")
    test_cases_hash = Parse::Ses.test_cases_hash(example_name)

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

  def self.convert_dnl_line(line)
    if line.include? "output"
      "Then sends #{line.split()[-1]}"
    elsif line.include? "from"
      "And go to #{line.split()[-1]}"
    elsif line.include? "hold"
      "And #{line}"
    elsif line.include? "passivate"
    else
      line[0].upcase + line[1..-1]
    end
  end

  def self.bdd_from_dnl(example_name, dnl_name, feature_name = "Test")
    test_cases_hash = Parse::Dnl.test_cases_hash(example_name, dnl_name)

    File.open "output/#{feature_name}.feature", "w" do |file|
      file.write("Feature: #{feature_name}\n")
      test_cases_hash.each do |test_case|
        file.write("\tScenario: #{test_case[0]}\n")
        test_case[1].each do |line|
          dnl_line = convert_dnl_line(line)
          file.write("\t\t#{dnl_line}\n") if dnl_line
        end
      end
    end
  end
end
