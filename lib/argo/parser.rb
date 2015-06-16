require 'argo/schema'

module Argo
  class Parser
    def initialize(source)
      @source = source
    end

    def root
      parse(@source)
    end

    def parse(subgraph)
      Schema.new.tap { |schema|
        subgraph.each do |key, value|
          if key == 'title'
            schema.title = value
          else
            schema.schemas[key] = parse(value)
          end
        end
      }
    end
  end
end
