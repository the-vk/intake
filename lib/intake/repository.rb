# frozen_string_literal: true

require 'singleton'

module Intake
  # Repository stores references to loggers by logger name.
  class Repository
    include Singleton

    # Initializes new instance of [Intake] class.
    def initialize
      @store = {}
      @mutex = Mutex.new
    end

    # Tests if logger with given name exists
    # @return [Boolean] true if logger exists; false otherwise.
    def key?(name)
      @store.key? canonize_name(name)
    end

    def get_or_add(name, &block)
      return nil if name.nil?

      name = canonize_name(name)
      unless @store.key? name
        @mutex.synchronize do
          create_logger_unsafe(name, &block) unless @store.key? name
        end
      end
      @store[name]
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

    def parent_name(name)
      separator_rindex = name.rindex('::')
      separator_rindex.nil? ? 'root' : name[0, separator_rindex]
    end

    def module_name(mod)
      mod.name
    end

    def create_logger_unsafe(name, &block)
      unless name == 'root'
        parent_logger_name = parent_name(name)
        parent_logger = @store[parent_logger_name] || create_logger_unsafe(parent_logger_name, &block)
      end
      @store[name] = block.call(name, parent_logger) unless @store.key?(name)
      @store[name]
    end
  end
end
