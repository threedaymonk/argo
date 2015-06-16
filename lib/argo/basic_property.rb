module Argo
  class BasicProperty
    def initialize(
      constraints: {},
      description: nil,
      name:,
      required: false
    )
      @constraints = constraints.freeze
      @description = description.freeze
      @name = name.freeze
      @required = !!required
    end

    attr_reader \
      :constraints,
      :description,
      :name,
      :required
    alias_method :required?, :required
  end
end
