require 'forwardable'

module Argo
  class ConstraintProcessor
    extend Forwardable

    NON_CONSTRAINT_PROPERTIES = %w[
      description
      items
      type
    ]

    def initialize(dereferencer)
      @dereferencer = dereferencer
    end

    def process(hash)
      process_hash(
        hash.reject { |k, _| NON_CONSTRAINT_PROPERTIES.include?(k) }
      )
    end

  private

    def_delegators :@dereferencer, :dereference, :reference?

    def symbolize_key(k)
      k.gsub(/[A-Z]/) { |m| "_#{m.downcase}" }.to_sym
    end

    def process_object(obj)
      case obj
      when Hash
        process_hash(obj)
      when Array
        obj.map { |v| process_object(v) }.freeze
      else
        obj.freeze
      end
    end

    def process_hash(hash)
      if reference?(hash)
        dereference(hash)
      else
        hash.
          map { |k, v| [symbolize_key(k), process_object(v)] }.
          to_h.
          freeze
      end
    end
  end
end
