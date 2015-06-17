module Argo
  class ImmutableKeywordStruct
    def self.new(default_parameters, &block)
      Class.new do
        def initialize(**kwargs)
          unknown_keys = kwargs.keys - __defaults__.keys
          if unknown_keys.any?
            raise ArgumentError, "unknown keyword: #{unknown_keys.first}"
          end
          __defaults__.each do |key, default|
            instance_variable_set("@#{key}", kwargs.fetch(key, default).freeze)
          end
        end

        attr_reader *default_parameters.keys

        class_eval &block if block

      private

        define_method :__defaults__ do
          default_parameters
        end
      end
    end
  end
end
