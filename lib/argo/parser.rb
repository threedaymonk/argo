require 'argo/dereferencer'
require 'argo/schema_factory'

module Argo
  class Parser
    def initialize(source)
      @source = source
    end

    def root
      @root ||= SchemaFactory.new(dereferencer).build(@source)
    end

  private

    def dereferencer
      @dereferencer ||= Dereferencer.new { root }
    end
  end
end
