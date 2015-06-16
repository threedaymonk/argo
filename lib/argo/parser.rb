require 'argo/schema_factory'

module Argo
  class Parser
    def initialize(source)
      @source = source
    end

    def root
      SchemaFactory.new.build(@source)
    end
  end
end
