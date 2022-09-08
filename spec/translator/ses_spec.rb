# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/event'
require_relative '../../lib/translator/ses'

describe Translator::Ses do
  describe '.bdd_from_ses' do
    let(:buffer) { StringIO.new }
    let(:filename) { 'output' }
    let(:filepath) { "#{Translator::OUTPUT_DIR}#{filename}.feature" }
    let(:events) do
      [
        [
          Event.new(sender: 'Customer', action: 'Hello', receiver: 'BankTeller'),
          Event.new(sender: 'BankTeller', action: 'Hi', receiver: 'Customer')
        ]
      ]
    end

    before do
      allow(File).to receive(:open).with(filepath, 'w').and_yield(buffer)
      described_class.new.bdd_from_ses(events, filename)
    end

    it 'includes feature name' do
      expect(buffer.string).to include('Feature: output')
    end

    it 'includes scenario' do
      expect(buffer.string).to include('Scenario: 0')
    end

    it 'includes cucumber when steps' do
      expect(buffer.string).to include('When Customer sends Hello to BankTeller')
    end

    it 'includes cucumber then steps' do
      expect(buffer.string).to include('Then BankTeller sends Hi to Customer')
    end
  end
end
