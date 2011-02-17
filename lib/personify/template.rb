module Personify
  class Template
    
    attr_reader :template
    
    def initialize(template)
      parser = PersonifyLanguageParser.new
      @template = parser.parse(template)
    end
    
    def render(local_assigns={}, context = DefaultContext.new)
      context.local_assigns = local_assigns
      @template.eval(context)
    end
    
  end
end