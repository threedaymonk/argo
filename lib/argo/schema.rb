module Argo
  class Schema
    def initialize(title: nil, schemas: {})
      @title = title.freeze
      @schemas = schemas.freeze
    end

    attr_reader :title, :schemas
  end
end
