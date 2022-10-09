[![.github/workflows/rsspec.yml](https://github.com/the-vk/intake/actions/workflows/rspec.yml/badge.svg)](https://github.com/the-vk/intake/actions/workflows/rspec.yml)

# intake

## Description

**intake** is a powerful and easy to use logging library.
The library is designed with multiple base principles:

* Be a drop-in replacement for Ruby `Logger`
* Advanced API to support structured logging
* Highly efficient non-blocking logger API

## Installation

```shell
gem install intake
```

## Design

**intake** has two primary components:

* Logger
* Sink

**Intake::Logger** is a component that captures a logging event and forwards that to **Intake::EventDrain** which is a single point to collect log events.

A logger may optionally filter events by filter to quickly discard events with level below threshold.

**Intake::Sink** is a component that receives event logs and writes to a permanent storage.

A sink may filter events by level, logger name, or any other event attributes.

## Examples

This example sets up logging to write messages to STDOUT.
**intake** writes messages in Ruby Logger format.
```ruby
require 'intake`

log = Intake[:root]
log.level = :info
Intake.add_sink Intake::IOSink.new($stdout)

log.debug 'debug message'
log.debug { 'proc debug message' }
# Logger methods can take a block to generate log message
# Blocks allow to delay expensive message evaluation until and unless event is logged
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
```

Output:

```
I, [2022-10-09T15:57:58.377963 #12484] INFO -- : info message
I, [2022-10-09T15:57:58.378097 #12484] INFO -- : proc info message
W, [2022-10-09T15:57:58.378121 #12484] WARN -- : warn message
W, [2022-10-09T15:57:58.378133 #12484] WARN -- : proc warn message
E, [2022-10-09T15:57:58.378169 #12484] ERROR -- : error message
E, [2022-10-09T15:57:58.378212 #12484] ERROR -- : proc error message
F, [2022-10-09T15:57:58.378255 #12484] FATAL -- : fatal message
F, [2022-10-09T15:57:58.378297 #12484] FATAL -- : proc fatal message
```

### Sinks and filters

**intake** supports multuple target sinks with various filters.

```ruby
log = Intake[:root]
log.level = :debug
io_sink = Intake::IOSink.new($stdout)
# filter is a proc-like object to make a decision on events
# event is accepted by sink if #call(event) returns true
io_sink.add_filter Intake::Filters::LevelFilter.new(:warn)
Intake.add_sink io_sink
file_sink = Intake::IOSink.new(File.new('/dev/null', 'a'))
file_sink.add_filter Intake::Filters::LevelFilter.new(:info)

log.debug 'debug message'     # not logged
log.info 'info message'       # logged to file
log.warn 'warn message'       # logged to both stdout and file
log.error 'error message'     # logged to both stdout and file
log.fatal 'fatal message'     # logged to both stdout and file
```

Output:

```
W, [2022-10-09T16:08:48.752905 #14476] WARN -- : warn message
E, [2022-10-09T16:08:48.752983 #14476] ERROR -- : error message
F, [2022-10-09T16:08:48.753031 #14476] FATAL -- : fatal message
```

### MDC

Mapped diagnostic context (MDC) is a thread-local storage to attach extra information to log events, e.g. operation id or correlation id.

```ruby
log = Intake[:root]
log.level = :info
sink = Intake::IOSink.new($stdout)
sink.formatter = ->(e) { "#{e.timestamp} [#{e[:correlation_id]}] - #{e.logger_name}: - #{e.message}\n" }
Intake.add_sink sink

log.info 'a message'

Intake::MDC[:correlation_id] = :abc

log.info 'message with MDC'

Intake::MDC.clear(:correlation_id)

log.info 'a message with no MDC'
```

Output:

```
2022-10-09 16:13:23 -0700 [] - root: - a message
2022-10-09 16:13:23 -0700 [abc] - root: - message with MDC
2022-10-09 16:13:23 -0700 [] - root: - a message with no MDC
```

### Structured logging

**Intake::Logger** methods takes optional keyword argument **meta** with a Hash with extra details about log event.
Sink may write meta to output in structured format that allows to query logs.

```ruby
log = Intake[:root]
log.level = :info
sink = Intake::IOSink.new($stdout)
sink.formatter = ->(e) { "#{e.timestamp} [#{e[:user_id]}] - #{e.logger_name}: - #{e.message}\n" }
Intake.add_sink sink

log.info 'a message', meta: { user_id: 'username' }
```

Output:

```
2022-10-09 16:18:21 -0700 [username] - root: - a message
```
### Ruby Logger adapter

**intake** provides an adapter to Ruby Logger API. Adapter can be used as drop-in replacement of regular Ruby Logger.

```ruby
require 'intake'

log = Intake[:root]
Intake.add_sink Intake::IOSink.new($stdout)
log.level = :debug
log = log.as_ruby_logger

log.add(Logger::Severity::FATAL, 'msg', 'sample')

log.debug 'debug'
log.info 'info'
log.warn 'warn'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'

log.warn { 'warn proc message' }

log = Intake[:root].as_ruby_logger(progname: 'sample')

log.debug 'debug'
log.info 'info'
log.warn 'warn'
log.error 'error'
log.fatal 'fatal'
log.unknown 'unknown'

log.warn { 'warn proc message' }
```

Output:

```
F, [2022-10-09T16:16:13.918872 #14918] FATAL -- sample: msg
D, [2022-10-09T16:16:13.918992 #14918] DEBUG -- : debug
I, [2022-10-09T16:16:13.919053 #14918] INFO -- : info
W, [2022-10-09T16:16:13.919114 #14918] WARN -- : warn
E, [2022-10-09T16:16:13.919143 #14918] ERROR -- : error
F, [2022-10-09T16:16:13.919191 #14918] FATAL -- : fatal
F, [2022-10-09T16:16:13.919219 #14918] FATAL -- : unknown
W, [2022-10-09T16:16:13.919267 #14918] WARN -- : warn proc message
D, [2022-10-09T16:16:13.919319 #14918] DEBUG -- sample: debug
I, [2022-10-09T16:16:13.919363 #14918] INFO -- sample: info
W, [2022-10-09T16:16:13.919417 #14918] WARN -- sample: warn
E, [2022-10-09T16:16:13.919442 #14918] ERROR -- sample: error
F, [2022-10-09T16:16:13.919491 #14918] FATAL -- sample: fatal
F, [2022-10-09T16:16:13.919542 #14918] FATAL -- sample: unknown
W, [2022-10-09T16:16:13.919594 #14918] WARN -- sample: warn proc message
```

## License

The MIT License. See the [LICENSE](/LICENSE) file for the full text.
