require 'pp'
require 'byebug'
class Lexer

  def tokenize(code)
    code.chomp!
    tokens = code.split(/。|！/).reduce([]) do |acc, sentence|
      acc << sentence_tokenize(sentence)
      acc
    end
    tokens
  end

  private

  def sentence_tokenize(sentence)
    sentence.chomp!
    tokens = sentence.split("\n").reduce([]) do |acc, line|
      acc << line_tokenize(line)
    end
    tokens
  end

  def line_tokenize(line)
    line.chomp!
    return [] if line.empty?
    tokens, rest_of_line = case
                        when line[/っていうのは/]
                          [[:DEFINE],
                            line.gsub(/っていうのは.*$/,'')]
                        when line[/を使って/]
                          [[],
                            line.gsub(/を使って.*$/,'')]
                        when line[/を返す/]
                          [[],
                            line.gsub(/を返す.*$/,'')]
                        when line[/してみて/]
                          [[],
                            line.gsub(/してみて.*$/,'')]
                        when line[/を(かけた結果|かけたもの)/]
                          [["*"],
                            line.gsub(/を(かけた結果|かけたもの).*$/,'')]
                        when line[/で/]
                          *rest, last = line.split(/で/)
                          return line_tokenize(last) + line_tokenize(rest.join)
                        when line[/と/]
                          return line.split(/と/).reduce([]) do |accu, partial_line|
                            accu + line_tokenize(partial_line)
                          end
                        when line[/[0-9]+/]
                          return [line[/[0-9]+/].to_i]
                        else
                          return [line]
                        end
    tokens + line_tokenize(rest_of_line)
  end

end
