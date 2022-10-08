# frozen_string_literal: true

require 'log_sinks'

RSpec.describe LogSinks do
  specify 'version to be 0.1.0' do
    expect(LogSinks::VERSION).to eq '0.2.0'
  end
end
