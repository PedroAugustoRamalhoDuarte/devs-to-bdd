example_name = "BankTellerExample"
ses_file = File.open("examples/#{example_name}/ses/#{example_name}.ses")

file_data = ses_file.readlines.map(&:chomp)
puts file_data
ses_file.close

