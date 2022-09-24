# frozen_string_literal: true

require 'singleton'

module LogSinks
  # Repository stores references to loggers by logger name.
  class Repository
    include Singleton

    # Initializes new instance of [LogSinks] class.
    def initialize
      @store = {}
      @mutex = Mutex.new
    end

    # Tests if logger with given name exists
    # @return [Boolean] true if logger exists; false otherwise.
    def key?(name)
      @store.key? canonize_name(name)
    end

    def get_or_add(name)
      name = canonize_name(name)
      logger = @store[name]

      if logger.nil?
        logger = @mutex.synchronize do
          @store[name] = yield(name) unless @store.key?(name)
          @store[name]
        end
      end
      logger
    end

    private

    def canonize_name(name)
      case name
      when :root, 'root' then 'root'
      when String then name
      when Symbol then name.to_s
      when Module then module_name(name)
      when Object then module_name(name.class)
      end
    end

    def module_name(mod)
      mod.name
    end
  end
end
