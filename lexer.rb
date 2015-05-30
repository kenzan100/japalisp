require 'pp'
require 'byebug'
class Lexer

  def scan_operator(chunk)
    partial_tokens = []
    if operands = chunk[/\s*(.+)(をかけた結果|をかけたもの)/,1]
      partial_tokens << [:*, "かけた結果"]
      identifier_operands = operands.split("と").map do |operand|
        [:IDENTIFIER, operand]
      end
      partial_tokens += identifier_operands
    end
    partial_tokens
  end

  def tokenize(code)
    code.chomp!
    tokens = []
    i = 0 #current char position
    while i < code.size
      chunk = code[i..-1]
      pp chunk
      case
      when def_matched = chunk[/\s*(.+)っていうのは/, 1]
        tokens << [:DEF, "def"] << [:IDENTIFIER, def_matched]
        i += chunk[/.+っていうのは/].size
      when arg_matched = chunk[/\s*(.+)を使って/,1]
        args = arg_matched.split("と")
        identifier_args = args.map do |arg|
          [:IDENTIFIER, arg]
        end
        tokens << [:ARGS, "arg"]
        tokens += identifier_args
        i += chunk[/.+を使って/].size
      when return_matched = chunk[/\s*(.+)を返す/,1]
        tokens << [:RETURN, "返す"]
        tokens += scan_operator(return_matched)
        i += chunk[/.+を返す.+$/].size
      when chunk[/.+。$/]
        tokens << [:TERM, "。"]
        i += chunk[/.+。$/].size
      else
        i += chunk.size
      end
    end
    tokens
  end
end
