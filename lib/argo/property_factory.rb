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
      expanded = expand_implicit_body(body)
      klass = class_for_type(expanded)
      klass.new(
        constraints: constraints(expanded),
        description: expanded['description'],
        required: required?(name),
        **additional_properties(klass, expanded)
      )
    end

  private

    def class_for_type(body)
      type = body.fetch('type')
      TYPE_MAP.fetch(type)
    end

    def additional_properties(klass, body)
      if klass == ArrayProperty
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

    def expand_implicit_body(body)
      if body.key?('$ref')
        expand_schema_ref(body)
      elsif (body.keys & %w[ oneOf anyOf ]).any?
        expand_implicit_object(body)
      elsif body.key?('enum')
        expand_implicit_enum(body)
      else
        body
      end
    end

    def expand_schema_ref(body)
      {
        'type' => 'object',
        'constraints' => {
          'oneOf' => [body]
        }
      }
    end

    def expand_implicit_enum(body)
      { 'type' => 'string' }.merge(body)
    end

    def expand_implicit_object(body)
      { 'type' => 'object' }.merge(body)
    end
  end
end
