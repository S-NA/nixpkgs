{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, grpc_google_iam_v1
, google_api_core
, google_cloud_access_context_manager
, google_cloud_org_policy
, google_cloud_os_config
, libcst
, proto-plus
, pytest
, pytest-asyncio
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05q0yaw6b553qmzylr45zin17h8mvi8yyyxhbv3cxa7f0ahviw8w";
  };

  propagatedBuildInputs = [
    grpc_google_iam_v1
    google_api_core
    google_cloud_access_context_manager
    google_cloud_org_policy
    google_cloud_os_config
    libcst
    proto-plus
  ];

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];

  # Remove tests intended to be run in VPC
  preCheck = ''
    rm -rf tests/system
  '';

  disabledTests = [ "asset_service_transport_auth_adc" ];

  pythonImportsCheck = [
    "google.cloud.asset"
    "google.cloud.asset_v1"
    "google.cloud.asset_v1p1beta1"
    "google.cloud.asset_v1p2beta1"
    "google.cloud.asset_v1p4beta1"
    "google.cloud.asset_v1p5beta1"
  ];

  meta = with stdenv.lib; {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/python-asset";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
