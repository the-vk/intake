# frozen_string_literal: true

require 'intake'

RSpec.describe Intake do
  specify 'version to be 0.1.0' do
    expect(Intake::VERSION).to eq '0.1.0'
  end
end
