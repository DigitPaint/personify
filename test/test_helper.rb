require 'rubygems'
require 'treetop'
require 'shoulda'
require File.join(File.expand_path(File.dirname(__FILE__)), "../lib/personify") 

require 'test/unit'

module ParserTestHelper
  def parse(input)
    result = @parser.parse(input)
    unless result
      puts @parser.terminal_failures.join("\n")
    end
    assert !result.nil?
    result
  end
end