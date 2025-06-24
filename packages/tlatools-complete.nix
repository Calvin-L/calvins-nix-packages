{lib, runCommand, jre, runtimeClasspath,
 bash, tlatools, tla-community-modules, tlaps}:

runCommand "tlatools-complete"

{
  propagatedBuildInputs = [
    tlaps
  ];
}

''
  CP1=${lib.strings.escapeShellArg (runtimeClasspath [tlatools tla-community-modules])}
  CP2="$(tlapm --where)"
  CP3='$TLA_PATH'

  function mkExe {
    local OUT="$1"
    local CLS="$2"
    echo '#!${bash}/bin/bash'                               >>"$OUT"
    echo "export CLASSPATH=''${CP1@Q}:''${CP2@Q}:''${CP3}"  >>"$OUT"
    echo '${jre}/bin/java -XX:+UseParallelGC' "$CLS" '"$@"' >>"$OUT"
    chmod +x "$OUT"
  }

  mkdir -p $out/bin

  mkExe "$out/bin/tlc2" 'tlc2.TLC'
  mkExe "$out/bin/tlc2repl" 'tlc2.REPL'
  mkExe "$out/bin/tla2sany" 'tla2sany.SANY'
  mkExe "$out/bin/tla2xml" 'tla2sany.xml.XMLExporter'
  mkExe "$out/bin/pcal" 'pcal.trans'
  mkExe "$out/bin/tla2tex" 'tla2tex.TLA'
''
