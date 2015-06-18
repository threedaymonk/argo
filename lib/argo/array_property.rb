require 'argo/property'

module Argo
  class ArrayProperty < Property
    def initialize(items:, **kwargs)
      super(**kwargs)
      @items = items
    end

    attr_reader :items
  end
end
