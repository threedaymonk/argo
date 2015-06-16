require 'argo/schema'

module Argo
  class Parser
    def initialize(source)
      @source = source
    end

    def root
      parse(@source)
    end

  private

    def parse(subgraph)
      Schema.new(
        title: title(subgraph),
        schemas: subschemas(subgraph),
        type: type(subgraph)
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

    def title(subgraph)
      _, t = subgraph.find { |k, _| element_kind(k) == :title }
      t
    end

    def subschemas(subgraph)
      subgraph.
        select { |k, _| element_kind(k) == :subschema }.
        inject({}) { |h, (k, v)| h.merge(k => parse(v)) }
    end

    def type(subgraph)
      _, t = subgraph.find { |k, _| element_kind(k) == :type }
      t ? t.to_sym : :object
    end
  end
end
