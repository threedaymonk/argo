require 'argo/immutable_keyword_struct'

module Argo
  Schema = ImmutableKeywordStruct.new(
    description: nil,
    properties: [],
    schemas: {},
    spec: nil,
    title: nil,
    type: :object,
    route: nil
  )
end
