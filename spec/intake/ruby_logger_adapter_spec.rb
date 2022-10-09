# frozen_string_literal: true

require 'stringio'

require_relative '../../lib/intake'
require_relative '../../lib/intake/ruby_logger_adapter'

RSpec.describe Intake::RubyLoggerAdapter do
  %i[debug info warn error fatal].each do |l|
    it "#{l} logs message in Ruby Logger format" do
      string_io = StringIO.new
      sink = Intake::IOSink.new(string_io)
      Intake::EventDrain.instance.add_sink(sink)
      log = Intake::Logger[:root]
      log.level = :debug
      log = log.as_ruby_logger

      ts = Time.new(2022, 1, 1)

      time_double = class_double(Time).as_stubbed_const
      allow(time_double).to receive(:now).and_return(ts)

      log.__send__(l, 'message')
      # rubocop:disable Layout/LineLength
      expect(string_io.string).to eq "#{l.to_s[0].upcase}, [2022-01-01T00:00:00.000000 ##{Process.pid}] #{l.to_s.upcase} -- : message\n"
      # rubocop:enable Layout/LineLength
    end
  end
end
