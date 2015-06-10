var expect = chai.expect;

describe("Jexer", function() {
  describe("tokenizeWhole", function() {
    it("should separate a multiplication Japanese sentence to series of tokens", function() {
      var sample = "掛け算っていうのは AとBを使って AとBをかけた結果を返すんだよ";
      var tokens = [[
        ["DEFINE", "掛け算"],
        ["A", "B"],
        ["*", ["A"], ["B"]]
      ]];
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
    it("should separate a factorial Japanese sentence to series of tokens", function() {
      var sample = "階乗っていうのは 数字を使って もしその数字が1だったら1を返して\
      それ以外だったら その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ"
      var tokens = [[
        ["DEFINE", "階乗"],
        ["数字"],
        ["IF", ["==", ["数字"], [1]], [1]],
        ["ELSE"],
        ["*", ["数字"], ["階乗", ["-", ["数字"], [1]]]]
      ]];
      console.log(Jexer.tokenizeWhole(sample).join());
      console.log(tokens.join());
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
  });
});

describe("Japalisp", function() {
  describe("eval", function() {
    it("should eval multiplication using user-defined lambda", function() {
      var sample = "掛け算っていうのは AとBを使って AとBをかけた結果を返すんだよ";
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var function_call_tokens = Jexer.tokenizeWhole("41と59で掛け算してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(2419);
    });
    it("should eval factorial number using user-defind lambda", function() {
      var sample = "階乗っていうのは 数字を使って もしその数字が1だったら1を返して\
      それ以外だったら その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ"
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var function_call_tokens = Jexer.tokenizeWhole("3で階乗してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(6);
    });
  });
});
