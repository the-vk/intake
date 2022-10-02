# frozen_string_literal: true

require 'concurrent'
require 'immutable/deque'

require_relative 'filter'

module LogSinks
  # Sink receives log event and writes to a permanent storage.
  class Sink
    THREAD_MODEL_VALID_TYPES = %i[same_thread dedicated_thread].freeze

    def initialize(thread_model:)
      raise ArgumentError, 'invalid thread_model' unless THREAD_MODEL_VALID_TYPES.include?(thread_model)

      @thread_model = thread_model
      @filters = []

      return unless @thread_model == :dedicated_thread

      @drain_buffer = Concurrent::AtomicReference.new
      @drain_buffer.set(Immutable::Deque.empty)
      @has_events_flag = Concurrent::Event.new
      @drain_thread = Thread.new { drain_thread_func }
    end

    def flush
      @has_events_flag.set if @thread_model == :dedicated_thread
    end

    def receive(event)
      return unless accept_event?(event)

      case @thread_model
      when :dedicated_thread
        @drain_buffer.update { |buffer| buffer.push(event) }
        @has_events_flag.set
      else drain(event)
      end
    end

    def add_filter(filter)
      @filters << filter
    end

    protected

    # Receives a message and write to a permanent storage
    def drain(_event)
      nil
    end

    def drain_thread_func
      @has_events_flag.reset

      loop do
        @has_events_flag.wait(0.1)
        @has_events_flag.reset

        backlog = nil
        loop do
          backlog = @drain_buffer.get
          break if @drain_buffer.compare_and_set(backlog, Immutable::Deque.empty)
        end

        until backlog.empty?
          e = backlog.first
          backlog = backlog.shift
          drain(e)
        end
      end
    end

    def accept_event?(event)
      proceed = true
      @filters.each do |f|
        proceed &&= f.call(event)
        break unless proceed
      end
      proceed
    end
  end
end
