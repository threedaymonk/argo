require 'argo/immutable_keyword_struct'

module Argo
  BasicProperty = ImmutableKeywordStruct.new(
    constraints: {},
    description: nil,
    name: nil,
    required: false
  ) do
    alias_method :required?, :required
  end
end
