# frozen_string_literal: true

require_relative '../lib/log_sinks'

log = LogSinks::Logger[:root]
log.level = :info
sink = LogSinks::IOSink.new($stdout)
sink.add_filter LogSinks::Filters::LevelFilter.new(:info)
LogSinks::EventDrain.instance.add_sink sink

log.debug 'debug message'
log.debug { 'proc debug message' }
log.debug do
  print("you don't see me!")
  'expensive proc debug message'
end
log.info 'info message'
log.info { 'proc info message' }
log.warn 'warn message'
log.warn { 'proc warn message' }
log.error 'error message'
log.error { 'proc error message' }
log.fatal 'fatal message'
log.fatal { 'proc fatal message' }

sink.add_filter LogSinks::Filters::LoggerNamePrefixFilter.new('Prog::Main', include_root: false)

log.info 'root logger event is skipped'

LogSinks::Logger['Prog::Main::Feature'].warn 'Prog::Main::Feature messages are logged'
LogSinks::Logger['Prog::Component'].fatal 'Prog::Component logs are ignored'
