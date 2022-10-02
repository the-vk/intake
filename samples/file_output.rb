# frozen_string_literal: true

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :info
LogSinks::EventDrain.instance.add_sink LogSinks::IOSink.new(File.new('/dev/null', 'a'))

log.info 'debug message'
