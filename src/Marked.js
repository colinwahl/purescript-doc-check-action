"use strict";
const marked = require("marked");

exports.getCodeBlocks = markdown => {
  const tokens = marked.lexer(markdown);
  const getCodeFromToken = token => {
    if (
      token.type === "code" &&
      (token.lang === "purs" || token.lang === "purescript")
    ) {
      return token.text;
    }
  };
  return tokens.map(getCodeFromToken);
};
