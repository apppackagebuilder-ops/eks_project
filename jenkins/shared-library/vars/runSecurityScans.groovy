// Shared library step for running Trivy image scans on service container images.
def call(String service, String registry, String tag) {
  sh "trivy image --exit-code 0 --format table ${registry}/${service}:${tag}"
  sh "trivy image --exit-code 1 --severity CRITICAL,HIGH ${registry}/${service}:${tag}"
}
