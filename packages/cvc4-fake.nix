{runCommandLocal, cvc5}:

runCommandLocal "cvc4-fake" {} ''
  mkdir -p "$out/bin"
  test -e "${cvc5}/bin/cvc5"
  ln -s "${cvc5}/bin/cvc5" "$out/bin/cvc4"
''
