module Parse::Dnl
  def self.get_passivate_event(line)
    line.split()[-1]
  end

  def self.test_cases_hash(example_name, dnl_name)
    dnl_file = File.open("examples/#{example_name}/dnl/#{dnl_name}.dnl")

    file_data = dnl_file.readlines.map(&:chomp)

    event_hash = {}
    actual_event = nil
    file_data.each do |line|
      # Ends of dnl file
      break if line == "passivate in passive!"

      line = line.delete("!")
      if line.include? "passivate"
        actual_event = get_passivate_event(line)
        event_hash[actual_event] = []
        event_hash[actual_event].append(line)
      else
        event_hash[actual_event].append(line) if actual_event
      end
    end

    dnl_file.close
    event_hash
  end
end