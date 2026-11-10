#!/usr/bin/env bash
set -euo pipefail
# AWS Academy Learner Lab: no almacenes credenciales en el repositorio.
# Pegar sesión AWS CLI en ~/.aws/credentials (perfil itba-academy) desde AWS Details.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TF_DIR="$ROOT/aws-demo/terraform"
export AWS_PROFILE="${AWS_PROFILE:-itba-academy}"
export AWS_REGION="${AWS_REGION:-us-east-1}"
for cmd in terraform aws curl; do
  command -v "$cmd" >/dev/null || { echo "Falta instalar: $cmd" >&2; exit 1; }
done
echo "Cuenta activa, verificar que sea TU AWS Academy:"
aws sts get-caller-identity
echo "Aplicando Terraform en $AWS_REGION con el rol IAM existente LabRole."
terraform -chdir="$TF_DIR" init -input=false
terraform -chdir="$TF_DIR" plan -input=false -var="aws_region=$AWS_REGION"
terraform -chdir="$TF_DIR" apply -input=false -var="aws_region=$AWS_REGION"
URL="$(terraform -chdir="$TF_DIR" output -raw api_url)"
echo "API URL (copiar a slide 18): $URL"
curl --fail --show-error --silent --max-time 15 "$URL/health"
echo
