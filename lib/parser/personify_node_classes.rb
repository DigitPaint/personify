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
      if fn = key.eval(env)
        if fn.respond_to?(:call)
          values = parameters.eval(env)
          values << self.block.eval(env) if self.block.kind_of?(Block)
          fn.call(*values)
        else
          fn
        end
      end
    end      
  end
  
  class Block < Treetop::Runtime::SyntaxNode
    def eval(env={})
      block_content.to_s
    end
  end
end