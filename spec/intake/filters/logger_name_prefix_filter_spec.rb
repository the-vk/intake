# frozen_string_literal: true

RSpec.describe Intake::Filters::LoggerNamePrefixFilter do
  it '#call returns true if include_root == true and logger_name == :root' do
    event = Intake::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      Intake::Level[:info],
      :root,
      'message'
    )
    filter_root = Intake::Filters::LoggerNamePrefixFilter.new('abc', include_root: true)
    expect(filter_root.call(event)).to be true

    filter_non_root = Intake::Filters::LoggerNamePrefixFilter.new('abc', include_root: false)
    expect(filter_non_root.call(event)).to be false
  end

  it '#call returns true if logger_name starts with filter prefix' do
    event = Intake::LogEvent.new(
      Time.new(2022, 1, 1, 13, 51, 41),
      Intake::Level[:info],
      'ABC::DEF',
      'message'
    )
    filter_pass = Intake::Filters::LoggerNamePrefixFilter.new('ABC')
    expect(filter_pass.call(event)).to be true

    filter_fail = Intake::Filters::LoggerNamePrefixFilter.new('DEF')
    expect(filter_fail.call(event)).to be false
  end
end
