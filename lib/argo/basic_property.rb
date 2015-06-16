module Argo
  class BasicProperty
    def initialize(name:, description: nil, required: false, constraints: {})
      @name = name.freeze
      @description = description.freeze
      @constraints = constraints.freeze
      @required = !!required
    end

    attr_reader :name, :description, :required, :constraints
    alias_method :required?, :required
  end
end
