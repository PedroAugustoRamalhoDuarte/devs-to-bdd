# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/translator/dnl'

describe Translator::Dnl do
  describe '.bdd_from_hash' do
    let(:buffer) { StringIO.new }
    let(:filename) { 'output' }
    let(:filepath) { "#{Translator::OUTPUT_DIR}#{filename}.feature" }
    let(:test_case_hash) do
      { 'waitforHello' => ['to start,passivate in waitforHello',
                           'when in waitforHello and receive Hello go to sendHi',
                           'hold in sendHi for time 1',
                           'after sendHi output Hi',
                           'from sendHi go to waitforRequestWithdrawal'] }
    end

    before do
      allow(File).to receive(:open).with(filepath, 'w').and_yield(buffer)
      described_class.new.bdd_from_hash(test_case_hash, filename)
    end

    it 'includes feature name' do
      expect(buffer.string).to include('Feature: output')
    end

    it 'includes scenario' do
      expect(buffer.string).to include('Scenario: waitforHello')
    end

    it 'includes cucumber when steps' do
      expect(buffer.string).to include('When in waitforHello and receive Hello go to sendHi')
    end

    it 'includes cucumber then steps' do
      expect(buffer.string).to include('Then sends Hi')
    end
  end
end
