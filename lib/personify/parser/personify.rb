# Autogenerated from a Treetop grammar. Edits may be lost.


module PersonifyLanguage
  include Treetop::Runtime

  def root
    @root ||= :template
  end

  def _nt_template
    start_index = index
    if node_cache[:template].has_key?(index)
      cached = node_cache[:template][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      r1 = _nt_parts_including_tail
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(Template,input, i0...index, s0)

    node_cache[:template][start_index] = r0

    r0
  end

  def _nt_parts_including_tail
    start_index = index
    if node_cache[:parts_including_tail].has_key?(index)
      cached = node_cache[:parts_including_tail][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_part
    if r1
      r0 = r1
    else
      r2 = _nt_tail_part
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:parts_including_tail][start_index] = r0

    r0
  end

  def _nt_part
    start_index = index
    if node_cache[:part].has_key?(index)
      cached = node_cache[:part][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_text
    if r1
      r0 = r1
    else
      r2 = _nt_substitutable
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:part][start_index] = r0

    r0
  end

  module TailPart0
    def part
      elements[1]
    end
  end

  def _nt_tail_part
    start_index = index
    if node_cache[:tail_part].has_key?(index)
      cached = node_cache[:tail_part][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('[', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_part
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(TailPart,input, i0...index, s0)
      r0.extend(TailPart0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:tail_part][start_index] = r0

    r0
  end

  module Substitutable0
    def space1
      elements[1]
    end

    def expressions
      elements[2]
    end

    def space2
      elements[3]
    end

  end

  def _nt_substitutable
    start_index = index
    if node_cache[:substitutable].has_key?(index)
      cached = node_cache[:substitutable][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('[', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_expressions
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            if has_terminal?(']', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(']')
              r5 = nil
            end
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Substitutable,input, i0...index, s0)
      r0.extend(Substitutable0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:substitutable][start_index] = r0

    r0
  end

  module Block0
    def space1
      elements[1]
    end

    def block_content
      elements[3]
    end

    def space2
      elements[5]
    end

  end

  def _nt_block
    start_index = index
    if node_cache[:block].has_key?(index)
      cached = node_cache[:block][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('DO', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('DO')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if has_terminal?(']', false, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_block_content
          s0 << r4
          if r4
            if has_terminal?('[', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('[')
              r5 = nil
            end
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if has_terminal?('END', false, index)
                  r7 = instantiate_node(SyntaxNode,input, index...(index + 3))
                  @index += 3
                else
                  terminal_parse_failure('END')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Block,input, i0...index, s0)
      r0.extend(Block0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:block][start_index] = r0

    r0
  end

  def _nt_block_content
    start_index = index
    if node_cache[:block_content].has_key?(index)
      cached = node_cache[:block_content][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      r1 = _nt_part
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(Literal,input, i0...index, s0)

    node_cache[:block_content][start_index] = r0

    r0
  end

  module Expressions0
    def space1
      elements[0]
    end

    def space2
      elements[2]
    end

    def expression_or_string
      elements[3]
    end
  end

  module Expressions1
    def expression
      elements[0]
    end

    def alternatives
      elements[1]
    end
  end

  def _nt_expressions
    start_index = index
    if node_cache[:expressions].has_key?(index)
      cached = node_cache[:expressions][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_expression
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          if has_terminal?("|", false, index)
            r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("|")
            r5 = nil
          end
          s3 << r5
          if r5
            r6 = _nt_space
            s3 << r6
            if r6
              r7 = _nt_expression_or_string
              s3 << r7
            end
          end
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(Expressions0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(Expressions,input, i0...index, s0)
      r0.extend(Expressions1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:expressions][start_index] = r0

    r0
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_function
    if r1
      r0 = r1
    else
      r2 = _nt_logical
      if r2
        r0 = r2
      else
        r3 = _nt_key
        if r3
          r0 = r3
        else
          r4 = _nt_string
          if r4
            r0 = r4
          else
            @index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  def _nt_expression_or_string
    start_index = index
    if node_cache[:expression_or_string].has_key?(index)
      cached = node_cache[:expression_or_string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_expression
    if r1
      r0 = r1
    else
      r2 = _nt_implicit_string
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:expression_or_string][start_index] = r0

    r0
  end

  module Function0
    def key
      elements[0]
    end

    def space1
      elements[1]
    end

    def space2
      elements[3]
    end

    def parameters
      elements[4]
    end

    def space3
      elements[5]
    end

    def space4
      elements[7]
    end

    def block
      elements[8]
    end
  end

  def _nt_function
    start_index = index
    if node_cache[:function].has_key?(index)
      cached = node_cache[:function][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_key
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        if has_terminal?("(", false, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("(")
          r3 = nil
        end
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_parameters
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                if has_terminal?(")", false, index)
                  r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(")")
                  r7 = nil
                end
                s0 << r7
                if r7
                  r8 = _nt_space
                  s0 << r8
                  if r8
                    r10 = _nt_block
                    if r10
                      r9 = r10
                    else
                      r9 = instantiate_node(SyntaxNode,input, index...index)
                    end
                    s0 << r9
                  end
                end
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Function,input, i0...index, s0)
      r0.extend(Function0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:function][start_index] = r0

    r0
  end

  module Parameters0
    def space1
      elements[0]
    end

    def space2
      elements[2]
    end

    def expression_or_string
      elements[3]
    end
  end

  module Parameters1
    def first_param
      elements[0]
    end

    def more_expressions
      elements[1]
    end
  end

  def _nt_parameters
    start_index = index
    if node_cache[:parameters].has_key?(index)
      cached = node_cache[:parameters][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_expression_or_string
    if r2
      r1 = r2
    else
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4, s4 = index, []
        r5 = _nt_space
        s4 << r5
        if r5
          if has_terminal?(",", false, index)
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(",")
            r6 = nil
          end
          s4 << r6
          if r6
            r7 = _nt_space
            s4 << r7
            if r7
              r8 = _nt_expression_or_string
              s4 << r8
            end
          end
        end
        if s4.last
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          r4.extend(Parameters0)
        else
          @index = i4
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(Parameter,input, i0...index, s0)
      r0.extend(Parameters1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:parameters][start_index] = r0

    r0
  end

  module Logical0
    def first_expression
      elements[0]
    end

    def space1
      elements[1]
    end

    def operator
      elements[2]
    end

    def space2
      elements[3]
    end

    def next_expression
      elements[4]
    end
  end

  def _nt_logical
    start_index = index
    if node_cache[:logical].has_key?(index)
      cached = node_cache[:logical][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_function
    if r2
      r1 = r2
    else
      r3 = _nt_key
      if r3
        r1 = r3
      else
        r4 = _nt_string
        if r4
          r1 = r4
        else
          @index = i1
          r1 = nil
        end
      end
    end
    s0 << r1
    if r1
      r5 = _nt_space
      s0 << r5
      if r5
        i6 = index
        if has_terminal?("||", false, index)
          r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure("||")
          r7 = nil
        end
        if r7
          r6 = r7
        else
          if has_terminal?("&&", false, index)
            r8 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure("&&")
            r8 = nil
          end
          if r8
            r6 = r8
          else
            @index = i6
            r6 = nil
          end
        end
        s0 << r6
        if r6
          r9 = _nt_space
          s0 << r9
          if r9
            r10 = _nt_expression
            s0 << r10
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(Logical,input, i0...index, s0)
      r0.extend(Logical0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:logical][start_index] = r0

    r0
  end

  module Key0
  end

  module Key1
  end

  def _nt_key
    start_index = index
    if node_cache[:key].has_key?(index)
      cached = node_cache[:key][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    i1 = index
    r2 = _nt_reserved
    if r2
      r1 = nil
    else
      @index = i1
      r1 = instantiate_node(SyntaxNode,input, index...index)
    end
    s0 << r1
    if r1
      i3, s3 = index, []
      if has_terminal?('\G[A-Z0-9]', true, index)
        r4 = true
        @index += 1
      else
        r4 = nil
      end
      s3 << r4
      if r4
        s5, i5 = [], index
        loop do
          if has_terminal?('\G[A-Z0-9._]', true, index)
            r6 = true
            @index += 1
          else
            r6 = nil
          end
          if r6
            s5 << r6
          else
            break
          end
        end
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        s3 << r5
      end
      if s3.last
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        r3.extend(Key0)
      else
        @index = i3
        r3 = nil
      end
      s0 << r3
    end
    if s0.last
      r0 = instantiate_node(Key,input, i0...index, s0)
      r0.extend(Key1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:key][start_index] = r0

    r0
  end

  def _nt_reserved
    start_index = index
    if node_cache[:reserved].has_key?(index)
      cached = node_cache[:reserved][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    if has_terminal?("END", false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure("END")
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if has_terminal?("DO", false, index)
        r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
        @index += 2
      else
        terminal_parse_failure("DO")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:reserved][start_index] = r0

    r0
  end

  module String0
    def string_value
      elements[1]
    end

  end

  def _nt_string
    start_index = index
    if node_cache[:string].has_key?(index)
      cached = node_cache[:string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('"', false, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_string_value
      s0 << r2
      if r2
        if has_terminal?('"', false, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('"')
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(PString,input, i0...index, s0)
      r0.extend(String0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:string][start_index] = r0

    r0
  end

  def _nt_implicit_string
    start_index = index
    if node_cache[:implicit_string].has_key?(index)
      cached = node_cache[:implicit_string][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[^|\\],)]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(Literal,input, i0...index, s0)
    end

    node_cache[:implicit_string][start_index] = r0

    r0
  end

  def _nt_string_value
    start_index = index
    if node_cache[:string_value].has_key?(index)
      cached = node_cache[:string_value][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[^"]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(Literal,input, i0...index, s0)

    node_cache[:string_value][start_index] = r0

    r0
  end

  module Text0
  end

  def _nt_text
    start_index = index
    if node_cache[:text].has_key?(index)
      cached = node_cache[:text][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[^\\[]', true, index)
      r1 = true
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[^\\[]', true, index)
          r3 = true
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(Literal,input, i0...index, s0)
      r0.extend(Text0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:text][start_index] = r0

    r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      if cached
        cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[ \\n]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:space][start_index] = r0

    r0
  end

end

class PersonifyLanguageParser < Treetop::Runtime::CompiledParser
  include PersonifyLanguage
end