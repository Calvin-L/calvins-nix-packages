{runCommand, makeWrapper, jre, runtimeClasspath, tlatools, tla-community-modules, tlaps}:

runCommand "tlatools-complete"

{
  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    tlatools.lib
    tla-community-modules
  ];
  propagatedBuildInputs = [
    tlaps
  ];
}

''
  export CP='${runtimeClasspath [tlatools tla-community-modules]}:'"$(tlapm --where)"':$TLA_PATH'

  mkdir -p $out/bin

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/tlc2" \
    --add-flags "-XX:+UseParallelGC tlc2.TLC" \
    --set CLASSPATH "$CP"

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/tlc2repl" \
    --add-flags "-XX:+UseParallelGC tlc2.REPL" \
    --set CLASSPATH "$CP"

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/tla2sany" \
    --add-flags "-XX:+UseParallelGC tla2sany.SANY" \
    --set CLASSPATH "$CP"

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/tla2xml" \
    --add-flags "-XX:+UseParallelGC tla2sany.xml.XMLExporter" \
    --set CLASSPATH "$CP"

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/pcal" \
    --add-flags "-XX:+UseParallelGC pcal.trans" \
    --set CLASSPATH "$CP"

  makeWrapper \
    '${jre}/bin/java' \
    "$out/bin/tla2tex" \
    --add-flags "-XX:+UseParallelGC tla2tex.TLA" \
    --set CLASSPATH "$CP"
''
