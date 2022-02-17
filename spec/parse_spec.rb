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
end