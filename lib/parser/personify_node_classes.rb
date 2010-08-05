module PersonifyLanguage
  class Literal < Treetop::Runtime::SyntaxNode
    def eval(env={})
      text_value
    end
    
    def to_s
      text_value
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
  
  class Block < Treetop::Runtime::SyntaxNode
    def eval(env={})
      block_content.to_s
    end
  end
end