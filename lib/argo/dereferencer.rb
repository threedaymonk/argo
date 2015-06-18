require 'lazy'

module Argo
  class Dereferencer
    def initialize(&block)
      @block = block
    end

    def dereference(hash)
      path = hash.fetch('$ref')
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

    def reference?(hash)
      hash.key?('$ref')
    end
  end
end
