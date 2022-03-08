# frozen_string_literal: true

module Parse
  module Dnl
    def self.get_passivate_event(line)
      line.split[-1]
    end

    def self.test_cases_hash(file_path)
      dnl_file = File.open(file_path)

      file_data = dnl_file.readlines.map(&:chomp)

      event_hash = {}
      actual_event = nil
      file_data.each do |line|
        # Ends of dnl file
        break if line == 'passivate in passive!'

        line = line.delete('!')
        if line.include? 'passivate'
          actual_event = get_passivate_event(line)
          event_hash[actual_event] = []
          event_hash[actual_event].append(line)
        elsif actual_event
          event_hash[actual_event].append(line)
        end
      end

      dnl_file.close
      event_hash
    end
  end
end
