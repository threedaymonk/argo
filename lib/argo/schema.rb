module Argo
  class Schema
    def initialize(title: nil, schemas: {}, type: :object, properties: [])
      @title = title.freeze
      @schemas = schemas.freeze
      @type = type
      @properties = properties
    end

    attr_reader :title, :schemas, :type, :properties
  end
end
