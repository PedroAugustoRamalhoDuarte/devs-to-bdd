def components_from_line(line)
  line.split('of')[1].split()
end

def extract_event(line)
  delimiters = [/\bto\b/, /\bsends\b/]
  line = line.split(',')[1]
  line_splited = line.split(Regexp.union(delimiters))
  {
    sender: line_splited[-3].strip,
    action: line_splited[-2].strip,
    receiver: line_splited[-1][..-2].strip # Removes !
  }
end

def test_cases_hash(example_name)
  example_name = example_name
  ses_file = File.open("examples/#{example_name}/ses/#{example_name}.ses")

  file_data = ses_file.readlines.map(&:chomp)

  event_list = []
  test_cases = []
  file_data.each do |line|
    # Extract components
    if line.include? "is made of"
      # passs
    elsif line.include? "From the" # Extract events
      event = extract_event(line)
      event_list.append(event)

      # If the first sender is now the receiver
      if event[:receiver] == event_list[0][:sender]
        # Closes one test case
        test_cases.append(event_list.dup)
        event_list.clear
      end
    end
  end

  ses_file.close

  test_cases
end

def event_to_s(event)
  "#{event[:sender]} send #{event[:action]} to #{event[:receiver]}"
end

def test_case_tag(event, test_case)
  if event == test_case.last
    "Then"
  elsif event == test_case.first
    "When"
  else
    "And"
  end
end

def bdd_from_test_cases(test_cases_hash, feature_name = "Test")
  File.open "output/#{feature_name}.feature", "w" do |file|
    file.write("Feature: #{feature_name}\n")
    test_cases_hash.each_with_index do |test_case, index|
      file.write("\tScenario: #{index}\n")
      test_case.each do |event|
        file.write("\t\t#{test_case_tag(event, test_case)} #{event_to_s(event)}\n")
      end
    end
  end
end

bdd_from_test_cases(test_cases_hash("BankTellerExample"), "BankTeller")