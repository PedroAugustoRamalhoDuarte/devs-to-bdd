# frozen_string_literal: true

require_relative './spec_helper'
require_relative '../lib/steps_generator'

describe StepsGenerator do
  let(:buffer) { StringIO.new }
  let(:output_path) { './output.rb' }
  let(:input_path) { './spec/fixture/Customer.feature' }

  describe ".call" do
    # Mock file system
    before do
      allow(File).to receive(:open).with(output_path, "w").and_return(buffer)
      described_class.new.call(input_path, output_path)
    end

    it "returns Then step" do
      expect(buffer.string).to include("Then('go to waitforHi') do")
    end

    it "returns When step" do
      expect(buffer.string).to include("When('holding in sendHello for time {int}')")
    end
  end
end