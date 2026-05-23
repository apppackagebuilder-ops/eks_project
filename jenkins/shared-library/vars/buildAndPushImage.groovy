// Shared library step for building and pushing a service container image to ECR.
def call(String service, String registry, String tag) {
  sh "docker build -t ${registry}/${service}:${tag} microservices/${service}"
  sh "docker push ${registry}/${service}:${tag}"
}
