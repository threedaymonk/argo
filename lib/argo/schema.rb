module Argo
  class Schema
    def initialize
      @schemas = {}
    end

    attr_accessor :title
    attr_reader :schemas
  end
end
