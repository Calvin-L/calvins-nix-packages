{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqez";
  version = "1.0.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R5h7NhAyMzdS9VZ2VRoHS3jbO5eCPRg6ND41wMGhGyg=";
  };

  pyproject = true;
  build-system = [hatchling];

  doCheck = true;
  nativeCheckInputs = [pytestCheckHook];
  pythonImportsCheck = ["sqez"];

  meta = {
    homepage = "https://github.com/Calvin-L/sqez";
    description = "Thin thread-safe wrapper around Python's sqlite3";
    license = lib.licenses.mit;
  };
}
