example_name = "BankTellerExample"
ses_file = File.open("examples/#{example_name}/ses/#{example_name}.ses")

file_data = ses_file.readlines.map(&:chomp)

def components_from_line(line)
  line.split('of')[1].split()
end

def extract_event(line)
end

components = []
list = []
file_data.each do |line|
  if line.include? "is made of"
    components = components_from_line(line)
  elsif line.include? "From then"
    list = []
  end
end

ses_file.close


