require File.dirname(__FILE__) + "/../vendor/treetop/lib/treetop"

require '../lib/parser/personify_node_classes'
Treetop.load "../lib/parser/personify"

# STR = "a [TAG] is never [TAG] with [TAG2] and [troepie] bla"
# STR = "[A1|B1|\"str\"] [A1|B1|str] [AB(T1)]"
# STR = "[AND(\"1\", 2,3)] <a href=\"http://mlr1.nl/r/[TOKEN]/539\"> financiële"
STR = "[FUN() DO]\nvalue\n[T1]\n[END | \"bla\"]"
# STR = "[FUN()]"
@parser = PersonifyLanguageParser.new

if result = @parser.parse(STR)
  puts "done"
  puts result  
  puts "=" * 50  
  puts result.inspect
  puts "=" * 50
  puts result.eval(
    "fun" => Proc.new{|p| "--#{p}--" },
    :t1 => "tt",
    :tag => "henk", 
    :ab => Proc.new{|p| p.inspect },
    :and => Proc.new{|*c| c.join(" & ") }
    ).inspect
else
  puts "FAIL"
  puts @parser.inspect
  puts "=" * 50
  puts @parser.terminal_failures.join("\n")
end
