# frozen_string_literal: true

RSpec.describe LogSinks::Filter do
  it '#call returns true' do
    filter = LogSinks::Filter.new
    expect(filter.call(nil)).to be true
  end
end
