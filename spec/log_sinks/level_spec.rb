# frozen_string_literal: true

require_relative '../../lib/log_sinks/level'

# rubocop:disable Metrics/BlockLength
RSpec.describe LogSinks::Level do
  %i[debug info warn error fatal].each do |l|
    it ".[#{l}] returns :#{l} level" do
      level = LogSinks::Level[l]
      expect(level.name).to eq l
    end
  end

  it '#< returns true if level less then other' do
    debug = LogSinks::Level[:debug]
    error = LogSinks::Level[:error]
    expect(debug < error).to be true
    expect(error < debug).to be false
  end

  it '#<= returns true if level less or equal then other' do
    debug = LogSinks::Level[:debug]
    error = LogSinks::Level[:error]
    expect(debug < error).to be true

    # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    expect(debug <= debug).to be true
    # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
  end

  it '#> returns true if level greater then other' do
    debug = LogSinks::Level[:debug]
    error = LogSinks::Level[:error]
    expect(debug > error).to be false
    expect(error > debug).to be true
  end

  it '#<= returns true if level greater or equal then other' do
    debug = LogSinks::Level[:debug]
    error = LogSinks::Level[:error]
    expect(debug > error).to be false

    # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    expect(debug >= debug).to be true
    # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
  end

  it '#== returns true if level equals' do
    debug = LogSinks::Level[:debug]
    # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
    expect(debug == debug).to be true
    # rubocop:enable Lint/BinaryOperatorWithIdenticalOperands
  end
end
# rubocop:enable Metrics/BlockLength
