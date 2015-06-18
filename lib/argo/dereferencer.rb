require 'lazy'

module Argo
  class Dereferencer
    def initialize(&block)
      @block = block
    end

    def dereference(path)
      fragments = path.split(/\//)
      unless fragments[0] == '#'
        raise "Can't dereference non-root-anchored path '#{path}'"
      end
      Lazy.promise {
        fragments.drop(1).inject(@block.call) { |schema, fragment|
          schema.schemas.fetch(fragment)
        }
      }
    end
  end
end
