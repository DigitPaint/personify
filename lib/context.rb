module Personify
  # This specifies the context we can evaluate in 
  class Context
    
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
      @local_assigns = assigns
    end
    
    def local_assigns
      @local_assigns ||= {}
    end
    
    def [](k)
      self.local_assigns[k]
    end
    
    def has_key?(k)
      self.local_assigns.has_key?(k)
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