#!/bin/bash
set -euo pipefail
# Fail Fast activado:
# -e  : el script se detiene si un comando falla
# -u  : el script se detiene si se usa una variable no definida
# -o pipefail : el script falla si falla cualquier comando en una tubería

##########################################################################################
# 0505AT - Script de Despliegue             						
# Autor: Rocío Magnoni     
# Fecha: 2025-04
# Descripción: Este script automatiza el despliegue de un sitio web estático en Minikube
##########################################################################################

### CONFIGURACIÓN ###
REPO_WEB="https://github.com/RocioMagnoni/static-website.git"
REPO_INFRA="https://github.com/RocioMagnoni/0311AT-K8S-INFRA.git"
BASE_DIR="${1:-$HOME/0311AT-K8S}"
MOUNT_PATH="/mnt/web"
CLUSTER_NAME="0311at"
DRIVER="docker"

### FUNCIONES AUXILIARES ###
function validar_dependencias() {
  echo "[INFO] Validando dependencias..."
  for cmd in git kubectl minikube; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "[ERROR] '$cmd' no está instalado o no está en el PATH." >&2
      exit 1
    fi
  done
}

function clonar_repos() {
  echo "[INFO] Clonando repositorios en '$BASE_DIR'..."
  mkdir -p "$BASE_DIR"
  cd "$BASE_DIR"

  [ -d "static-website" ] || git clone "$REPO_WEB" static-website
  [ -d "0311AT-K8S-INFRA" ] || git clone "$REPO_INFRA" 0311AT-K8S-INFRA
}

function iniciar_minikube() {
  echo "[INFO] Iniciando cluster Minikube con volumen montado..."
  minikube start -p "$CLUSTER_NAME" --driver="$DRIVER" \
    --mount --mount-string="${BASE_DIR}/static-website:${MOUNT_PATH}"
}

function aplicar_manifiestos() {
  echo "[INFO] Aplicando manifiestos Kubernetes..."
  local manifiestos_dir="$BASE_DIR/0311AT-K8S-INFRA/manifiestos_k8s"
  cd "$manifiestos_dir"

  kubectl apply -f pv-pvc/persistent-volume.yaml
  kubectl apply -f pv-pvc/persistent-volume-claim.yaml
  kubectl apply -f deployment/deployment.yaml
  kubectl apply -f service/service.yaml
}

function verificar_recursos() {
  echo "[INFO] Verificando recursos desplegados..."

  echo "[INFO] Esperando a que el pod esté en estado 'Running'..."
  for i in {1..20}; do
    POD_STATUS=$(kubectl get pods -l app=web -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "NotFound")
    if [[ "$POD_STATUS" == "Running" ]]; then
      echo "[OK] Pod en estado Running"
      break
    fi
    echo "Esperando pod... ($i/20)"
    sleep 5
  done

  if [[ "$POD_STATUS" != "Running" ]]; then
    echo "[ERROR] El pod no llegó al estado Running. Abortando despliegue." >&2
    exit 1
  fi

  kubectl get pods
  kubectl get svc
  kubectl get deployments
}

function acceder_sitio() {
  echo "[INFO] Abriendo sitio desplegado..."
  minikube -p "$CLUSTER_NAME" service static-site-service
}

### EJECUCIÓN ###
echo "=== Despliegue Automático - 0505AT Abril 2025 ==="
validar_dependencias
clonar_repos
iniciar_minikube
aplicar_manifiestos
verificar_recursos
acceder_sitio



