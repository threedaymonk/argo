require 'argo/basic_property'

module Argo
  class ArrayProperty < BasicProperty
    def initialize(items:, **kwargs)
      super(**kwargs)
      @items = items
    end

    attr_reader :items
  end
end
