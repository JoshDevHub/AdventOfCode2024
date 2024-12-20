module Cachable
  def self.prepended(base) = base.extend(ClassMethods)

  module ClassMethods
    def cache(method_name)
      Cachable.define_method(method_name) do |*args|
        @_cache ||= {}
        @_cache[[method_name, *args]] ||= super(*args)
      end
    end
  end
end
