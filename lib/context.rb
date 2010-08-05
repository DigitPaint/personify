module Personify
  # This specifies the context we can evaluate in 
  class Context < Hash
    
    class << self
      def allowed_context_methods
        @allowed_methods ||= []
      end
      
      def context_method(method_name)
        self.allowed_context_methods << method_name.to_s if self.instance_methods.include?(method_name.to_s)
      end
      
      def allow_method?(method_name)
        self.allowed_context_methods.include?(method_name.to_s)
      end
    end

    def allow_method?(method_name)
      self.class.allow_method?(method_name)
    end
    
    def local_assigns=(assigns)
      self.update(assigns)
    end
    
    
  end
  
  class DefaultContext < Context
    
    def if(statement, value)    
      if statement
        value
      else
        nil
      end
    end
    context_method :if
    
  end
end