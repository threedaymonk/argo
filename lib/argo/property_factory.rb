require 'argo/string_property'
require 'argo/integer_property'
require 'argo/number_property'
require 'argo/array_property'

module Argo
  class PropertyFactory
    def initialize(required_fields = [])
      @required_fields = required_fields
    end

    def build(name, body)
      class_for_type(body).new(
        constraints: constraints(body),
        description: body['description'],
        name: name,
        required: required?(name),
        **additional_properties(body)
      )
    rescue => e
      raise e, e.message + ' in ' + body.inspect
    end

  private

    def class_for_type(body)
      case body['type']
      when 'string'
        StringProperty
      when 'integer'
        IntegerProperty
      when 'number'
        NumberProperty
      when 'array'
        ArrayProperty
      else
        if body['enum']
          StringProperty
        else
          raise "Unknown property type '#{type}'"
        end
      end
    end

    def additional_properties(body)
      case body['type']
      when 'array'
        additional_properties_for_array(body)
      else
        {}
      end
    end

    def additional_properties_for_array(body)
      { items: PropertyFactory.new.build('item', body['items']) }
    end

    def required?(name)
      @required_fields.include?(name)
    end

    NON_CONSTRAINT_PROPERTIES = %w[
      description
      items
      type
    ]

    def constraints(hash)
      hash.
        reject { |k, _| NON_CONSTRAINT_PROPERTIES.include?(k) }.
        map { |k, v| [k.to_sym, v.freeze] }.
        to_h
    end
  end
end
