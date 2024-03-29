# frozen_string_literal: true

require_relative '../parse'
require_relative '../event'
require_relative 'strategy'

# Defines strategy for parse ses files
class Parse::Ses < Parse::Strategy
  # @see Parse::Strategy#test_cases_hash
  def test_cases_hash(file_path)
    ses_file = File.open(file_path)

    file_data = ses_file.readlines.map(&:chomp)

    event_list = []
    test_cases = []
    file_data.each_with_index do |line, index|
      # Extract components
      if line.include? 'is made of'
        # pass
      elsif line.include? 'From the' # Extract events
        event = extract_event(line)
        event_list.append(event)

        # If the first sender is now the receiver
        if event.receiver == event_list[0].sender
          # TODO: Check this logic (BSNExample vs JazzBand)
          next_line = file_data[index + 1]
          unless next_line.nil?
            next_line_event = extract_event(next_line)
            # Check if next line sender is receiver and is the last line
            if (next_line_event.sender == event.receiver) && (file_data.length == index + 2)
              event_list.append(next_line_event)
            end
          end
          # Closes one test case
          test_cases.append(event_list.dup)
          event_list.clear
        end
      end
    end

    ses_file.close

    test_cases
  end

  private

  # Extract event from a ses file line and creates event
  #
  # @return [Event]
  def extract_event(line)
    delimiters = [/\bto\b/, /\bsends\b/]
    line = line.split(',')[1]
    line_splited = line.split(Regexp.union(delimiters))
    ::Event.new(sender: line_splited[-3].strip,
                action: line_splited[-2].strip,
                receiver: line_splited[-1][..-2].strip)
  end
end
