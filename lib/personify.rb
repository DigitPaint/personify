require 'treetop'

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

require_relative 'personify/parser/personify_node_classes'
require_relative 'personify/parser/personify'
require_relative 'personify/template'
require_relative 'personify/context'

module Personify
end