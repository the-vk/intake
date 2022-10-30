# frozen_string_literal: true

require 'intake'

RSpec.describe Intake do
  specify 'version to be 0.3.0' do
    expect(Intake::VERSION).to eq '0.3.0'
  end
end
