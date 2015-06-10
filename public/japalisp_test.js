var expect = chai.expect;

describe("Jexer", function() {
  describe("tokenizeWhole", function() {
    it("should separate a Japanese sentence to series of tokens", function() {
      var sample = "掛け算っていうのは AとBを使って AとBをかけた結果を返すんだよ";
      var tokens = [[
        ["DEFINE", "掛け算"],
        ["A", "B"],
        ["*", ["A"], ["B"]]
      ]];
      console.log(Jexer.tokenizeWhole(sample).join());
      console.log(tokens.join());
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
  });
});

describe("Japalisp", function() {
  describe("eval", function() {
    it("should eval Jexer tokens into computed value", function() {
      var sample = "掛け算っていうのは AとBを使って AとBをかけた結果を返すんだよ";
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var function_call_tokens = Jexer.tokenizeWhole("41と59で掛け算してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(2419);
    });
  });
});
