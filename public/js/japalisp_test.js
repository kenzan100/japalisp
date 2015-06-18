var expect = chai.expect;

describe("Jexer", function() {
  describe("tokenizeWhole", function() {
    it("should separate a add1 Japanese sentence to series of tokens", function() {
      var sample = "1に1を足してみて";
      var tokens = [[
        ["+", [1], [1]]
      ]];
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
    it("should separate a multiplication Japanese sentence to series of tokens", function() {
      var sample = "掛け算っていうのは、 AとBを使って、 AとBをかけた結果を返すんだよ。";
      var tokens = [[
        ["DEFINE", "掛け算"],
        ["A", "B"],
        ["*", ["A"], ["B"]]
      ]];
      // console.log(JSON.stringify(Jexer.tokenizeWhole(sample)));
      // console.log(JSON.stringify(tokens));
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
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
    it("should separate exponential Japanese sentence to tokens", function(){
      var sample ="べき乗っていうのは、\
      数字Aと数字Bを使って、\
      もし数字Bが0なら1を返して、\
      それ以外なら\
      数字Aと、数字Aと数字Bから1を引いた数でべき乗をした結果で俺の掛け算をしたものを返すんだよ。";
      var tokens = [[
        ["DEFINE", "べき乗"],
        ["数字A","数字B"],
        ["IF", ["==", ["数字B"], [0]], [1]],
        ["ELSE"],
        ["俺の掛け算", ["数字A"], ["べき乗", ["数字A"], ["-", ["数字B"], [1]]]]
      ]];
      expect(Jexer.tokenizeWhole(sample)).to.eql(tokens);
    });
  });
});

describe("Japalisp", function() {
  describe("eval", function() {
    it("should eval add1 from the start", function() {
      var function_call_tokens = Jexer.tokenizeWhole("1に1を足してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(2);
    });
    it("should eval multiplication using user-defined lambda", function() {
      var sample = "掛け算っていうのは AとBを使って AとBをかけた結果を返すんだよ";
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var function_call_tokens = Jexer.tokenizeWhole("41と59で掛け算してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(2419);
    });
    it("should eval factorial number using user-defined lambda", function() {
      var sample = "階乗っていうのは 数字を使って もしその数字が1だったら1を返して\
      それ以外だったら その数字と、その数字から1を引いた数で階乗をした結果をかけたものを返すんだよ"
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var function_call_tokens = Jexer.tokenizeWhole("3で階乗してみて");
      var computed_val = Japalisp.eval(function_call_tokens, Japalisp.globalEnvironment);
      expect(computed_val).to.equal(6);
    });
    it("should eval exponential number using user-defined lambda", function() {
      var user_defined_multiplication = "掛け算っていうのは、 AとBを使って、 AとBをかけた結果を返すんだよ。";
      Japalisp.eval(Jexer.tokenizeWhole(user_defined_multiplication), Japalisp.globalEnvironment);
      var sample = "べき乗っていうのは、\
      数字Aと数字Bを使って、\
      もし数字Bが0なら1を返して、\
      それ以外なら\
      数字Aと、数字Aと数字Bから1を引いた数でべき乗をした結果で掛け算をしたものを返すんだよ。";
      Japalisp.eval(Jexer.tokenizeWhole(sample), Japalisp.globalEnvironment);
      var computed_val = Japalisp.eval(Jexer.tokenizeWhole("3と2でべき乗してみて"), Japalisp.globalEnvironment);
      expect(computed_val).to.equal(9);
    });
  });
});
