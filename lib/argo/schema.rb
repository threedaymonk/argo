module Argo
  class Schema
    def initialize(
      description: nil,
      properties: [],
      schemas: {},
      spec: nil,
      title: nil,
      type: :object
    )
      @description = description.freeze
      @properties = properties.freeze
      @schemas = schemas.freeze
      @spec = spec.freeze
      @title = title.freeze
      @type = type
    end

    attr_reader \
      :description,
      :properties,
      :schemas,
      :spec,
      :title,
      :type
  end
end
