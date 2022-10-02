# frozen_string_literal: true

require_relative '../../lib/log_sinks'

RSpec.describe LogSinks::Logger do
  it '.[] returns the same logger instance' do
    logger_a = LogSinks::Logger[:abc]
    logger_b = LogSinks::Logger[:abc]
    expect(logger_a).to equal(logger_b)
  end

  it '#initialize raises error if name is not a String' do
    expect { LogSinks::Logger.new(123) }.to raise_error ArgumentError
    expect { LogSinks::Logger.new('123') }.not_to raise_error
  end
end
