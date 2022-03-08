require_relative '../lib/parse/ses'

describe "Parser" do
  describe "#extract_event" do
    let(:line) { 'From the BankTellerExamplesys perspective, Customer sends Hello to BankTeller!' }
    it "returns components and action type" do
      expect(Parse::Ses.extract_event(line).to_s).to eq("Customer sends Hello to BankTeller")
    end
  end

  describe "#test_cases_hash" do
    let(:example_name) { './examples/BankTellerExample/ses/BankTellerExample.ses' }
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
      expect(Parse::Ses.test_cases_hash(example_name)[0].map(&:to_h)).to eq(test_case_one)
    end
  end
end