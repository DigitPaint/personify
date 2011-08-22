module PersonifyLanguage
  class Template < Treetop::Runtime::SyntaxNode
    def eval(env={})
      elements.map{|e| e.eval(env) }.join("")
    end    
  end

  class TailPart  < Treetop::Runtime::SyntaxNode
    def eval(env)
      "[" + part.eval(env)
    end
  end
  
  class Substitutable < Treetop::Runtime::SyntaxNode
    def eval(env)
      # puts expressions.inspect
      last_eval = expressions.eval(env)
      if last_eval.nil?
        text_value
      else
        last_eval
      end
    end    
  end
  
  class Expressions < Treetop::Runtime::SyntaxNode
    def eval(env)
      last_value = nil
      expressions.detect do |exp|
        last_value = exp.eval(env)
      end
      last_value
    end
    
    def expressions
      [expression] + alternatives.elements.map {|elt| elt.expression_or_string}
    end    
  end
  
  class Key < Treetop::Runtime::SyntaxNode
    def eval(env)
      keys = self.to_s.split(".")
      keys.inject(env){|acc,k| acc && acc[k] }
    end
          
    def name
      text_value
    end
    
    def to_s
      self.name.downcase.to_s
    end    
  end
  
  class PString < Treetop::Runtime::SyntaxNode
    def eval(env={})
      string_value.eval(env)
    end    
  end
  
  class Literal < Treetop::Runtime::SyntaxNode
    def eval(env={})
      text_value
    end
    
    def to_s
      text_value
    end
  end
  
  class Logical < Treetop::Runtime::SyntaxNode
    def eval(env)
      fe = first_expression.eval(env)
      ne = next_expression.eval(env)
      
      case operator.text_value
        when "&&" then fe && ne
        when "||" then fe || ne
      end
    end    
  end
  
  class Function < Treetop::Runtime::SyntaxNode
    def eval(env={})
      if env.respond_to?(:allow_method?) && env.allow_method?(key.to_s)
        fn = env.method(key.to_s)
      else 
        fn = self.key.eval(env)
      end
      
      if fn && fn.respond_to?(:call)
        fn.call(*self.function_parameters(env))
      else
        fn
      end
    rescue StandardError
      return nil
    end
    
    def function_parameters(env)
      values = parameters.eval(env)
      values << self.block.eval(env) if self.block.kind_of?(Block)
      values    
    end     
  end
  
  class Parameter < Treetop::Runtime::SyntaxNode
    def eval(env={})
      self.parameters.map{|param| param.eval(env) }
    end
    def parameters
      (self.first_param.respond_to?(:eval) ? [first_param] : []) + more_expressions.elements.map {|elt| elt.expression_or_string}
    end    
  end
  
  class Block < Treetop::Runtime::SyntaxNode
    def eval(env={})
      block_content.to_s
    end
  end
end