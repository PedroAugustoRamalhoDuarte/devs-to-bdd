require 'parse'

describe "Parser" do
  describe "#extract_event" do
    let(:line) { 'From the BankTellerExamplesys perspective, Customer sends Hello to BankTeller!' }
    it "returns components and action type" do
      event = {
        sender: 'Customer',
        action: 'Hello',
        receiver: 'BankTeller'
      }
      expect(extract_event(line)).to eq(event)
    end
  end

  describe "#test_cases_hash" do
    let(:example_name) { 'BankTellerExample' }
    let(:test_case_one) {
      [
        {
          sender: 'Customer',
          action: 'Hello',
          receiver: 'BankTeller'
        },
        {
          sender: 'BankTeller',
          action: 'Hi',
          receiver: 'Customer'
        }
      ]
    }

    it "returns right event test cases" do
      expect(test_cases_hash(example_name)[0]).to eq(test_case_one)
    end
  end
end