require 'treetop'
require '../lib/parser/personify_node_classes'
require '../lib/context'
Treetop.load "../lib/parser/personify"

# STR = "a [TAG] is never [TAG] with [TAG2] and [troepie] bla"
# STR = "[A1|B1|\"str\"] [A1|B1|str] [AB(T1)]"
# STR = "[AND(\"1\", 2,3)] <a href=\"http://mlr1.nl/r/[TOKEN]/539\"> financiële"
# STR = "[FUN() DO]\nvalue\n[T1]\n[END | \"bla\"] bla [FUN() DO]OER![END | '']"
# STR = "[IF(DETECT(FALSE,FALSE, TRUE)) DO]yes[END | \"\"]"
STR = "[A || B]"
# STR = "[TRUE DO]bla[END]"
# STR = "[FUN()]"
@parser = PersonifyLanguageParser.new

class TheContext < Personify::DefaultContext
  
  context_method :if
  
  def detect(*statements)
    statements.detect{|s| s }
  end
  context_method :detect  
end

def clean_tree(root_node)
   return if(root_node.elements.nil?)
   root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
   root_node.elements.each {|node| clean_tree(node) }
end

if result = @parser.parse(STR)
  puts "done"
  puts result  
  puts "=" * 50  
  # clean_tree(result)
  puts result.inspect
  puts "=" * 50
  
  t = TheContext.new
  t.local_assigns  = {
      "a" => "lA",
      "b" => "lB",
      "fun" => Proc.new{|p| "--#{p}--" },
      "true" => true,
      "false" => false,
      "t1" => "tt",
      "tag" => "henk", 
      "ab" => Proc.new{|p| p.inspect },
      "and" => Proc.new{|*c| c.join(" & ") }
  }
    
  puts result.eval(t).inspect
else
  puts "FAIL"
  puts @parser.inspect
  puts "=" * 50
  puts @parser.terminal_failures.join("\n")
end
