require 'argo/string_property'
require 'argo/integer_property'

module Argo
  class PropertyFactory
    def initialize(required_fields)
      @required_fields = required_fields
    end

    def build(name, body)
      class_for_type(body['type']).new(
        name: name,
        required: required?(name),
        description: body['description'],
        constraints: constraints(body)
      )
    end

  private

    def class_for_type(type)
      case type
      when 'string'
        StringProperty
      when 'integer'
        IntegerProperty
      end
    end

    def required?(name)
      @required_fields.include?(name)
    end

    NON_CONSTRAINT_PROPERTIES = %w[ type description ]
    def constraints(hash)
      hash.
        reject { |k, _| NON_CONSTRAINT_PROPERTIES.include?(k) }.
        map { |k, v| [k.to_sym, v.freeze] }.
        to_h
    end
  end
end
