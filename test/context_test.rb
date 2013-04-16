# coding: utf-8
require File.join(File.expand_path(File.dirname(__FILE__)), "test_helper") 
Treetop.load  File.dirname(__FILE__) + "/../lib/personify/parser/personify"

# Use this if you want to test the generated parser
# require_relative  "../personify"

class ContextTest < Test::Unit::TestCase
  include ParserTestHelper
  
  context "A Context class" do
    setup do
      @parser = PersonifyLanguageParser.new
      
      @c = Class.new(Personify::Context) do
        def true
          "true"
        end
        context_method :true
        
        def block(blk)
          "|#{blk}|"
        end
        context_method :block
        
        def do_not_call
          raise
        end
        
      end
    end
    
    should "have the context methods in the #allowed_methods" do
      assert @c.allowed_context_methods.include?(:true)
      assert @c.allowed_context_methods.include?(:block)
      assert !@c.allowed_context_methods.include?(:do_not_call)
    end
    
    should "respond true to #allow_method? of context method" do
      assert @c.allow_method?(:true)
      assert @c.allow_method?("true")
      assert @c.allow_method?(:block)
      assert @c.allow_method?("block")
      assert !@c.allow_method?(:do_not_call)
      assert !@c.allow_method?("do_not_call")
    end
    
    should "allow setting of local_assigns" do
      @i = @c.new
      assert @i.local_assigns = {:key => "value"}
      assert @i.has_key?(:key)
      assert_equal "value", @i[:key]
    end
    
    should "allow calling of a context method" do
      assert_equal "true", parse("[TRUE()]").eval(@c.new)
    end
    
    should "not allow calling of non context methods" do
      assert_equal "[DO_NOT_CALL()]", parse("[DO_NOT_CALL()]").eval(@c.new)
    end
    
    should "allow calling of a context method with block" do
      assert_equal "|out|", parse("[BLOCK(\"out\")]").eval(@c.new)
      assert_equal "|out|", parse("[BLOCK() DO]out[END]").eval(@c.new)      
    end
    
  end
  
  
  context "The DefaultContext" do
    setup do
      @context = Personify::DefaultContext.new
      @context.local_assigns = {"value" => "value", "empty" => "", "nil" => nil, "false" => false}
      
      @parser = PersonifyLanguageParser.new
    end

    context "if method" do
          
      should "accept 2 arguments" do
        assert_equal "out", parse("[IF(\"true\", \"out\")]").eval(@context)
        assert_equal "out", parse("[IF(\"true\") DO]out[END]").eval(@context)
      end
      
      should "not raise exception with 1 argument" do
        assert_nothing_raised do
          parse("[IF(\"out\")]").eval(@context)
        end
      end
            
      should "not raise exception with more than 2 arguments" do
        assert_nothing_raised do
          parse("[IF(\"out\", \"2\", \"3\")]").eval(@context)
        end
      end
            
      should "return nil with one argument" do
        assert_equal "[IF(\"out\")]", parse("[IF(\"out\")]").eval(@context)
      end
      
      should "discard any argument after the 2nd" do
        assert_equal "2", parse("[IF(\"out\", \"2\", \"3\")]").eval(@context)
        assert_equal "2", parse("[IF(\"out\", \"2\", \"3\") | \"test\"]").eval(@context)        
        assert_equal "2", parse("[IF(\"out\",\"2\") DO]3[END]").eval(@context)
      end
      
      should "return second argument if first argument is not empty" do
        assert_equal "out", parse("[IF(\"true\", \"out\")]").eval(@context)
        assert_equal "out", parse("[IF(\"true\") DO]out[END]").eval(@context)        
        assert_equal "out", parse("[IF(VALUE) DO]out[END]").eval(@context)
        assert_equal "out", parse("[IF(EMPTY) DO]out[END]").eval(@context)        
      end
      
      should "return nil if first argument is false" do
        assert_equal "[IF(NIL) DO]out[END]", parse("[IF(NIL) DO]out[END]").eval(@context)
        assert_equal "[IF(FALSE) DO]out[END]", parse("[IF(FALSE) DO]out[END]").eval(@context)
        assert_equal "", parse("[IF(FALSE) DO]out[END | \"\"]").eval(@context)        
      end
      
      should "be able to do if-elsif-else with | operator" do
        templ = "[IF(THIS) DO]this[END | IF(THAT) DO]that[END | \"other\"]"

        @context.local_assigns = {"this" => true, "that" => true}
        assert_equal "this", parse(templ).eval(@context)
        
        @context.local_assigns = {"this" => false, "that" => true}
        assert_equal "that", parse(templ).eval(@context)

        @context.local_assigns = {"this" => false, "that" => false}
        assert_equal "other", parse(templ).eval(@context)        
      end
      
    end
    
  end
  
end