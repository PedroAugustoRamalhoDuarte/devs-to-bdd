# frozen_string_literal: true

require_relative '../parse'
require_relative 'strategy'

# Defines strategy for parse dnl files
class Parse::Dnl < Parse::Strategy
  # @see Parse::Strategy#test_cases_hash
  def test_cases_hash(file_path)
    dnl_file = File.open(file_path)

    file_data = dnl_file.readlines.map(&:chomp)

    event_hash = {}
    actual_event = nil
    ignore_line = false
    file_data.each do |line|
      # Ends of dnl FILE
      break if line == 'passivate in passive!'

      line = line.delete('!').strip

      if end_custom_code_keyword(line)
        # Close Custom code
        ignore_line = false
        next
      end

      next if ignore_line

      if initial_custom_code_keyword(line)
        # Ignore custom code lines
        ignore_line = true
      elsif line.include?('passivate')
        # Passive elements start conditions
        actual_event = get_passivate_event(line)
        event_hash[actual_event] = []
        event_hash[actual_event].append(line)
      elsif line.include?('to start') && line.include?('hold')
        # Initial elements start condition
        actual_event = get_start_event(line)
        event_hash[actual_event] = []
        event_hash[actual_event].append(line)
      elsif actual_event
        event_hash[actual_event].append(line)
      end
    end

    dnl_file.close
    event_hash
  end

  private

  # Extract event from a passivate line
  #
  # @example
  #
  #   Parse::dnl.get_passivate_event("to start,passivate in waitforHello") # => "waitforHello"
  def get_passivate_event(line)
    line.split[-1]
  end

  # Extract event from a start action line
  #
  # @example
  #
  #   Parse::dnl.get_start_event("to start, hold in sendHello for time 1!") # => "hold in sendHello"
  def get_start_event(line)
    line.split[2..4].join(' ')
  end

  # Checks if lines is custom code begin
  #
  # @return [Boolean]
  def initial_custom_code_keyword(line)
    line.include?('internal event') || line.include?('<%') ||
      line.include?('external event') || line.include?('output event')
  end

  # Checks if lines is custom code end
  #
  # @return [Boolean]
  def end_custom_code_keyword(line)
    line.include?('%>')
  end
end
