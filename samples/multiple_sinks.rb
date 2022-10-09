# frozen_string_literal: true

require_relative '../lib/intake'

log = Intake[:root]
log.level = :debug
io_sink = Intake::IOSink.new($stdout)
io_sink.add_filter Intake::Filters::LevelFilter.new(:warn)
Intake.add_sink io_sink
file_sink = Intake::IOSink.new(File.new('/dev/null', 'a'))
file_sink.add_filter Intake::Filters::LevelFilter.new(:info)

log.debug 'debug message'     # not logged
log.info 'info message'       # logged to file
log.warn 'warn message'       # logged to both stdout and file
log.error 'error message'     # logged to both stdout and file
log.fatal 'fatal message'     # logged to both stdout and file
