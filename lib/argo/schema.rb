module Argo
  class Schema
    def initialize(title: nil, schemas: {}, type: :object)
      @title = title.freeze
      @schemas = schemas.freeze
      @type = type
    end

    attr_reader :title, :schemas, :type
  end
end
