# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/parse/dnl'

describe Parse::Dnl do
  describe '#test_cases_hash' do
    let(:example_name) { './examples/BankTellerExample/dnl/BankTeller.dnl' }
    let(:test_case_wait_for_hello) do
      ['to start,passivate in waitforHello',
       'when in waitforHello and receive Hello go to sendHi',
       'hold in sendHi for time 1',
       'after sendHi output Hi',
       'from sendHi go to waitforRequestWithdrawal']
    end

    it 'returns right event test cases' do
      expect(described_class.new.test_cases_hash(example_name)['waitforHello']).to eq(test_case_wait_for_hello)
    end
  end
end
