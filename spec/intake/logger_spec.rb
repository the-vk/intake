# frozen_string_literal: true

require_relative '../../lib/intake'

RSpec.describe Intake::Logger do
  it '.[] returns the same logger instance' do
    logger_a = Intake::Logger[:abc]
    logger_b = Intake::Logger[:abc]
    expect(logger_a).to equal(logger_b)
  end

  it '#initialize raises error if name is not a String' do
    expect { Intake::Logger.new(123) }.to raise_error ArgumentError
    expect { Intake::Logger.new('123') }.not_to raise_error
  end
end
