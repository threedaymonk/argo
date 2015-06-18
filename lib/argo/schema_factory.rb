require 'forwardable'
require 'argo/schema'
require 'argo/property_factory'

module Argo
  class SchemaFactory
    extend Forwardable

    def initialize(dereferencer)
      @dereferencer = dereferencer
    end

    def_delegators :@dereferencer, :dereference, :reference?

    def build(subgraph, route = [])
      Schema.new(
        description: extract_one(subgraph, :description),
        title: extract_one(subgraph, :title),
        schemas: subschemas(subgraph, route),
        type: type(subgraph),
        properties: properties(subgraph),
        spec: extract_one(subgraph, :$schema),
        route: route
      )
    end

    NON_SUBSCHEMA_PROPERTIES = %w[
      $schema
      additionalItems
      additionalProperties
      description
      id
      properties
      required
      title
      type
    ]

    def element_kind(key)
      NON_SUBSCHEMA_PROPERTIES.include?(key) ? key.to_sym : :subschema
    end

    def extract(subgraph, kind)
      subgraph.select { |k, _| element_kind(k) == kind }
    end

    def extract_one(subgraph, kind, default: nil)
      _, v = subgraph.find { |k, _| element_kind(k) == kind }
      v || default
    end

    def subschemas(subgraph, route)
      extract(subgraph, :subschema).
        inject({}) { |h, (k, v)| h.merge(k => build(v, route + [k])) }
    end

    def type(subgraph)
      extract_one(subgraph, :type, default: :object).to_sym
    end

    def properties(subgraph)
      required_fields = extract_one(subgraph, :required, default: [])
      factory = PropertyFactory.new(@dereferencer, required_fields)
      extract_one(subgraph, :properties, default: {}).
        map { |k, v|
          [k, reference?(v) ? dereference(v) : factory.build(v, name: k)]
        }.
        to_h
    end
  end
end
