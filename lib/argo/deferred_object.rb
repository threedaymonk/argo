require 'delegate'

module Argo
  class DeferredObject < Delegator
    instance_methods.each do |m|
      unless m =~ /^__|^(respond_to\?|method_missing|object_id)$/
        undef_method m
      end
    end

    def initialize(&block)
      @__delegator_block__ = block
      @__mutex__ = Mutex.new
    end

    def __getobj__
      @__mutex__.synchronize do
        @__getobj__ ||= @__delegator_block__.call
      end
      @__getobj__
    end
  end
end
