require 'argo/array_property'
require 'argo/boolean_property'
require 'argo/integer_property'
require 'argo/number_property'
require 'argo/object_property'
require 'argo/string_property'

module Argo
  class PropertyFactory
    NON_CONSTRAINT_PROPERTIES = %w[
      description
      items
      type
    ]

    TYPE_MAP = {
      'array' => ArrayProperty,
      'boolean' => BooleanProperty,
      'integer' => IntegerProperty,
      'number' => NumberProperty,
      'object' => ObjectProperty,
      'string' => StringProperty
    }

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
      implicit_class(body) || explicit_class(body)
    end

    def explicit_class(body)
      type = body['type']
      raise "Unknown property type '#{type}'" unless TYPE_MAP.key?(type)
      TYPE_MAP.fetch(type)
    end

    def implicit_class(body)
      body.key?('enum') && StringProperty
    end

    def additional_properties(body)
      if class_for_type(body) == ArrayProperty
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

    def constraints(hash)
      hash.
        reject { |k, _| NON_CONSTRAINT_PROPERTIES.include?(k) }.
        map { |k, v| [symbolize_key(k), symbolize_object(v)] }.
        to_h.
        freeze
    end

    def symbolize_key(k)
      k.gsub(/[A-Z]/) { |m| "_#{m.downcase}" }.to_sym
    end

    def symbolize_object(obj)
      case obj
      when Hash
        obj.map { |k, v| [symbolize_key(k), symbolize_object(v)] }.to_h.freeze
      when Array
        obj.map { |v| symbolize_object(v) }.freeze
      else
        obj.freeze
      end
    end
  end
end
