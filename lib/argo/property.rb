require 'argo/immutable_keyword_struct'

module Argo
  Property = ImmutableKeywordStruct.new(
    constraints: {},
    description: nil,
    required: false
  ) do
    alias_method :required?, :required
  end
end
