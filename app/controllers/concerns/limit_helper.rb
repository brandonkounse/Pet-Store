# frozen_string_literal: true

extend Limiter::Mixin

module LimitHelper
  def limit(*methods)
    methods.each do |method|
      limit_method(method, rate: 5, interval: 1) { print 'Limit reached!' }
    end
  end
end
