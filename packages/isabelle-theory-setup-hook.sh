addIsabellePath() {
  addToSearchPath ISABELLE_PATH $1/heaps
}
addEnvHooks "$hostOffset" addIsabellePath
