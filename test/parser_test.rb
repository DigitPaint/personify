require 'test_helper'
require File.dirname(__FILE__) + "/../vendor/treetop/lib/treetop"
Treetop.load "../lib/parser/personify"
# require File.dirname(__FILE__) + "/../personify"

class ParserTest < Test::Unit::TestCase
  include ParserTestHelper
  context "The parser" do
    setup do
      @parser = PersonifyLanguageParser.new
    end
    
    context "parsing keys" do
      should "eval [A] as key" do
        assert_equal "test", parse("[A]").eval({"a" => "test"})
      end
      
      should "eval [A_B] as key" do
        assert_equal "test", parse("[A_B]").eval({"a_b" => "test"})        
      end      
      
      should "eval [A.B] as nested key" do
        assert_equal "test", parse("[A.B]").eval({"a.b" => "fail", "a" => {"b" => "test"}})
      end
                  
      should "eval [AB_C.D] as nested key" do
        assert_equal "test", parse("[AB_C.D]").eval({"ab_c.d" => "fail", "ab_c" => {"d" => "test"}})
      end
            
      should "eval [L1.L2.L3.L4.L5.L6.L7.L8] as nested key" do
        assert_equal "test", parse("[L1.L2.L3.L4.L5.L6.L7.L8]").eval({"l1" => {"l2" => {"l3" => {"l4" => {"l5" => {"l6" => {"l7" => {"l8" => "test"}}}}}}}})          
      end
      
      should "eval [1.2] as nested key" do
        assert_equal "test", parse("[1.2]").eval({"1" => {"2" => "test"}})
      end
    end
    
    context "parsing strings" do
      should "eval [\"str\"] as string" do
        assert_equal "str", parse("[\"str\"]").eval({})
      end
    end
    
    context "parsing text" do
      should "eval text" do
        assert_equal "text", parse("text").eval()
        assert_equal "t", parse("t").eval()
        assert_equal "t\n1\n2", parse("t\n1\n2").eval()       
      end
      
      should "eval UTF8 text" do
        assert_equal "financiële", parse("financiële").eval()
      end
  
      should "eval empty text" do
        assert_equal "", parse("").eval()
      end
  
      should "eval '[bla]' as text" do
        assert_equal "[bla]", parse("[bla]").eval()
      end

      should "eval '[KE bla' as text" do
        assert_equal "[KE bla", parse("[KE bla").eval()
      end

      should "eval nested brackets as text" do
        assert_equal "[[BLA]]", parse("[[BLA]]").eval
      end

      should "eval '[BLA]' as text on nil 'bla' " do
        assert_equal "[BLA]", parse("[BLA]").eval()
      end
    end
    
    context "parsing expressions" do  
      should "eval simple expression" do
        assert_equal "var", parse("[VAR]").eval("var" => "var")
        assert_equal "a var b", parse("a [VAR] b").eval("var" => "var")
        assert_equal "var\nvar", parse("[VAR]\n[VAR]").eval("var" => "var")              
      end
      
      should "eval simple expression with empty substitution" do
        assert_equal "", parse("[VAR]").eval("var" => "")
      end
      
      should "eval expressions careless of whitespace" do
        assert_equal "k1",parse("[ K1]").eval("k1" => "k1")
        assert_equal "k1",parse("[ K1 ]").eval("k1" => "k1")
        assert_equal "k1",parse("[K1 | K2]").eval("k1" => "k1")
      end   
     
      context "with alternatives" do    
        should "eval alternative expression on first empty" do       
          assert_equal "k2", parse("[K1|K2]").eval("k2" => "k2")
          assert_equal "k2", parse("[K1|K2]").eval("k2" => "k2")
          assert_equal "k3", parse("[K1|K2|K3]").eval("k1" => nil,"k2" => nil, "k3" => "k3")
        end

        should "eval first expression on first nonempty" do       
          assert_equal "k2", parse("[K1|K2]").eval("k2" => "k2")
          assert_equal "k3", parse("[K1|K2|K3]").eval("k2" => nil, "k3" => "k3")
        end     

        should "eval strings in alternative expression" do 
          assert_equal "str", parse("[K1|str]").eval
          assert_equal "str", parse("[K1|\"str\"]").eval
          assert_equal "str", parse("[K1|\"str\"]").eval          
          assert_equal " str", parse("[K1|\" str\"]").eval
        end
        
        should "eval implicit strings in alternative expression" do 
          assert_equal "str", parse("[K1|str]").eval
        end        
      end
      
      context "with nested context substitutions" do
        should "not eval [A.B] if it isn't in the context" do
          assert_equal "[A.B]", parse("[A.B]").eval({})
          assert_equal "[A.B]", parse("[A.B]").eval({"a" => {"c" => "v"}})
        end        
        should "eval functions with one or more levels" do
          assert_equal "v", parse("[LEVEL1.FUNC()]").eval({"level1" => {"func" => Proc.new{"v"}}})
        end
        should "eval substitution with missing key" do
          assert_equal "[L1.L2]", parse("[L1.L2]").eval({"L1" => nil})
          assert_equal "[L1.L2]", parse("[L1.L2]").eval({"L1" => {}})
          assert_equal "[L1.L2]", parse("[L1.L2]").eval({"L1" => {"L2" => nil}})
        end
        should "eval substitution with non endpoint key" do
          # Will just call to_s
          assert_equal "l3v", parse("[L1.L2]").eval({"l1" => {"l2" => {"l3" => "v"}}})
        end
      end
      
      context "with function" do
        should "eval with single parameter" do
          assert_equal "v", parse("[FUNC(K1)]").eval("func" => Proc.new{|v| v }, "k1" => "v")
        end
        should "eval with multiple parameters" do
          assert_equal "v1v2", parse("[FUNC(K1,K2)]").eval("func" => Proc.new{|*v| v.join }, "k1" => "v1", "k2" => "v2")
        end
        should "eval with string parameters" do
          assert_equal "str", parse("[FUNC(\"str\")]").eval("func" => Proc.new{|v| v }, "k1" => "v1", "k2" => "v2")
        end
        should "eval with implicit string parameters" do
          assert_equal "str", parse("[FUNC(str)]").eval("func" => Proc.new{|v| v }, "k1" => "v1", "k2" => "v2")
        end        
        should "eval with splat parameters" do
          assert_equal "v1+v2v3", parse("[FUNC(\"v1\",\"v2\",\"v3\")]").eval("func" => Proc.new{|v1,*v2| v1 + "+" + v2.join })
        end
        should "eval with too much parameters" do
          assert_equal "p1p2", parse("[FUNC(\"p1\",\"p2\")]").eval("func" => Proc.new{|v1| v1 })
        end
        should "eval with no parameters" do 
          assert_equal "val", parse("[FUNC()]").eval("func" => Proc.new{ "val" })
        end
        should "eval with alternative expression" do
          assert_equal "fb", parse("[FUNC()|\"fb\"]").eval("func" => Proc.new{ false })
          assert_equal "fb", parse("[FUNC()|\"fb\"]").eval("func" => Proc.new{ nil })
        end
        should "eval with broken function call" do
          assert_equal "[FUN(\"s\"]", parse("[FUN(\"s\"]").eval("func" => Proc.new{})
        end
      end
      
      context "with block function" do
        setup do
          @context = {
            "test" => Proc.new{|block| block },
            "test_param" => Proc.new{|param,block| param ? block : nil },
            "test_return" => Proc.new{ "return" },
            "true" => true,
            "false" => nil,
            "key" => "value",
            "DO" => "dooo?"
          }
        end
        
        should "not accept [END] or [DO] as keys" do
          assert_equal "[END]", parse("[END]").eval({"end" => "??"})
          assert_equal "[DO]", parse("[DO]").eval({"do" => "??"})          
        end
        
        should "eval" do
          assert_equal "value", parse("[TEST() DO]value[END]").eval(@context)
        end
        
        should "eval with parameter" do
          assert_equal "value", parse("[TEST_PARAM(TRUE) DO]value[END]").eval(@context)
        end

        should "replace with return value" do
          assert_equal "return", parse("[TEST_RETURN() DO]value[END]").eval(@context)
        end
                
        should "eval as alternative with block parameter" do
          assert_equal "value", parse("[UNKNOWN_KEY | TEST() DO]value[END]").eval(@context)
        end
        
        should "eval with block parameter and alternative" do
          assert_equal "value", parse("[TEST_PARAM(TRUE) DO]value[END | \"alt\"]").eval(@context)
          assert_equal "alt", parse("[TEST_PARAM(FALSE) DO]value[END | \"alt\"]").eval(@context)      
        end
        
        should "eval substitution within block parameter" do
          assert_equal "value", parse("[TEST() DO][KEY][END]").eval(@context)
          assert_equal "bla value bla", parse("[TEST() DO]bla [KEY] bla[END]").eval(@context)
        end
        
        should "strip off \\s*\\n around DO] and [END]" do
          assert_equal "value", parse("[TEST() DO]\s\s\nvalue[END]\n").eval(@context)
          assert_equal "value ", parse("[TEST() DO]\s\s\nvalue [END]\n").eval(@context)
          assert_equal "value  ", parse("[TEST() DO]\s\s\nvalue [END] ").eval(@context)
          assert_equal " value ", parse("[TEST() DO]\s\s\n value [END]").eval(@context)
          assert_equal "\nvalue\n", parse("[TEST() DO]\s\s\n\nvalue\n[END]").eval(@context)
          assert_equal "\nvalue\n", parse("[TEST() DO]\s\s\n\nvalue\n[END]\n").eval(@context)
        end
        
      end
      
    end
  end
end
