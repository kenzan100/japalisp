require 'pp'
require 'byebug'
class Lexer

  def line_tokenize(code)
    return [] if code.empty?
    tokens, rest_code = case
                        when code[/っていうのは/]
                          [[[:DEF, "def"]],
                            code.gsub(/っていうのは.*$/,'')]
                        when code[/を使って/]
                          [[[:ARGS, "arg"]],
                            code.gsub(/を使って.*$/,'')]
                        when code[/を返す/]
                          [[[:RETURN, "返す"]],
                            code.gsub(/を返す.*$/,'')]
                        when code[/してみて/]
                          [[[:CALL, "してみて"]],
                            code.gsub(/してみて.*$/,'')]
                        when operands = code[/を(かけた結果|かけたもの)/,1]
                          [[[:*, operands]],
                            code.gsub(/を(かけた結果|かけたもの).*$/,'')]
                        when code[/で/]
                          *rest, last = code.split(/で/)
                          return line_tokenize(last) + line_tokenize(rest.join)
                        when code[/と/]
                          return code.split(/と/).reduce([]) do |accu, partial_code|
                            accu + line_tokenize(partial_code)
                          end
                        when code[/[0-9]+/]
                          return [[:NUMBER, code[/[0-9]+/].to_i]]
                        else
                          return [[:IDENTIFIER, code]]
                        end
    tokens + line_tokenize(rest_code)
  end

  def tokenize(code)
    code.chomp!
    tokens = code.split("\n").reduce([]) do |acc, line|
      acc + line_tokenize(line)
    end
    tokens
  end
end
