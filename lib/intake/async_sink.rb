# frozen_string_literal: true

require 'concurrent'
require 'immutable/deque'

module Intake
  # Received events and asynchronously forward events to downstream sink
  class AsyncSink
    def initialize(forward_sink)
      @forward_sink = forward_sink
      @drain_buffer = Concurrent::AtomicReference.new
      @drain_buffer.set(Immutable::Deque.empty)
      @has_events_flag = Concurrent::Event.new
      @drain_thread = Thread.new { drain_thread_func }
    end

    def receive(event)
      @drain_buffer.update { |buffer| buffer.push(event) }
      @has_events_flag.set
    end

    protected

    def drain_thread_func
      @has_events_flag.reset

      loop do
        @has_events_flag.wait(0.1)
        @has_events_flag.reset

        drain_backlog(snapshot_backlog)
      end
    end

    def snapshot_backlog
      backlog = nil
      loop do
        backlog = @drain_buffer.get
        break if @drain_buffer.compare_and_set(backlog, Immutable::Deque.empty)
      end
      backlog
    end

    def drain_backlog(backlog)
      until backlog.empty?
        e = backlog.first
        backlog = backlog.shift
        @forward_sink.receive(e)
      end
    end
  end
end
