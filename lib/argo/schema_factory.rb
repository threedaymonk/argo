require 'argo/schema'
require 'argo/property_factory'

module Argo
  class SchemaFactory
    def build(subgraph)
      Schema.new(
        title: title(subgraph),
        schemas: subschemas(subgraph),
        type: type(subgraph),
        properties: properties(subgraph)
      )
    end

    def element_kind(key)
      case key
      when 'title', 'properties', 'type', 'required'
        key.to_sym
      else
        :subschema
      end
    end

    def extract(subgraph, kind)
      subgraph.select { |k, _| element_kind(k) == kind }
    end

    def extract_one(subgraph, kind, default: nil)
      _, v = subgraph.find { |k, _| element_kind(k) == kind }
      v || default
    end

    def title(subgraph)
      extract_one(subgraph, :title)
    end

    def subschemas(subgraph)
      extract(subgraph, :subschema).
        inject({}) { |h, (k, v)| h.merge(k => build(v)) }
    end

    def type(subgraph)
      extract_one(subgraph, :type, default: :object).to_sym
    end

    def properties(subgraph)
      required_fields = extract_one(subgraph, :required, default: [])
      factory = PropertyFactory.new(required_fields)
      extract_one(subgraph, :properties, default: {}).
        map { |k, v| factory.build(k, v) }
    end
  end
end
