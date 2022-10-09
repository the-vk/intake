# frozen_string_literal: true

RSpec.describe Intake::Filter do
  it '#call returns true' do
    filter = Intake::Filter.new
    expect(filter.call(nil)).to be true
  end
end
