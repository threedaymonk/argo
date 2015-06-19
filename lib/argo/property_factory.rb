require 'forwardable'

require 'argo/array_property'
require 'argo/boolean_property'
require 'argo/integer_property'
require 'argo/number_property'
require 'argo/object_property'
require 'argo/string_property'

require 'argo/constraint_processor'

module Argo
  class PropertyFactory
    extend Forwardable

    TYPE_MAP = {
      'array' => ArrayProperty,
      'boolean' => BooleanProperty,
      'integer' => IntegerProperty,
      'number' => NumberProperty,
      'object' => ObjectProperty,
      'string' => StringProperty
    }

    def initialize(dereferencer, required_fields = [])
      @dereferencer = dereferencer
      @required_fields = required_fields
    end

    def_delegators :@dereferencer, :dereference, :reference?

    def build(body, name: nil)
      class_for_type(body).new(
        constraints: constraints(body),
        description: body['description'],
        required: required?(name),
        **additional_properties(body)
      )
    end

  private

    def class_for_type(body)
      klass = explicit_class(body) || implicit_class(body)
      raise "No type found in #{body.inspect}" unless klass
      klass
    end

    def explicit_class(body)
      return nil unless body.key?('type')
      type = body.fetch('type')
      raise "Unknown property type '#{type}'" unless TYPE_MAP.key?(type)
      TYPE_MAP.fetch(type)
    end

    def implicit_class(body)
      if body.key?('enum')
        StringProperty
      elsif (body.keys & %w[ oneOf anyOf ]).any?
        ObjectProperty
      end
    end

    def additional_properties(body)
      if class_for_type(body) == ArrayProperty
        additional_properties_for_array(body)
      else
        {}
      end
    end

    def additional_properties_for_array(body)
      items = [body.fetch('items')].flatten.first
      if reference?(items)
        value = dereference(items)
      else
        factory = PropertyFactory.new(@dereferencer)
        value = factory.build(items)
      end
      { items: value }
    end

    def required?(name)
      @required_fields.include?(name)
    end

    def constraints(hash)
      ConstraintProcessor.new(@dereferencer).process(hash)
    end
  end
end
