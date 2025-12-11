#!/usr/bin/env bash
set -euo pipefail

echo "=== APP_VM provisioning start ==="

# --------- 0. Base variables ----------
APP_USER="appuser"
APP_HOME="/home/${APP_USER}"
APP_DIR="${APP_HOME}"

PROJECT_ROOT="/opt/step_project_1"
PROJECT_DIR="${PROJECT_ROOT}/PetClinic"

GIT_URL="git@gitlab.com:Nebomriy/petclinic_step_project_1.git"
GIT_BRANCH="main"
SPARSE_PATH="PetClinic/*"

# DB env
DB_HOST="${DB_HOST:-192.168.56.10}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-petclinic}"
DB_USER="${DB_USER:-petuser}"
DB_PASS="${DB_PASS:-petpass}"

export DEBIAN_FRONTEND=noninteractive

echo "=== 1) Updating packages and installing Java + git ==="
apt-get update -y
apt-get install -y openjdk-8-jdk git unzip openssh-client ca-certificates mysql-client

echo "=== 2) Creating user ${APP_USER} (if not exists) ==="
if id "${APP_USER}" >/dev/null 2>&1; then
  echo "User ${APP_USER} already exists, skipping."
else
  useradd -m -s /bin/bash "${APP_USER}"
fi

echo "=== 3) Creating ${PROJECT_ROOT} and setting ownership ==="
mkdir -p "${PROJECT_ROOT}"
chown -R "${APP_USER}:${APP_USER}" "${PROJECT_ROOT}"

echo "=== 4) SSH for ${APP_USER} + GitLab key from /vagrant (if exists) ==="
sudo -u "${APP_USER}" mkdir -p "${APP_HOME}/.ssh"
chmod 700 "${APP_HOME}/.ssh"

if [ -f /vagrant/id_ed25519_gitlab_vagrant ]; then
  echo "Found /vagrant/id_ed25519_gitlab_vagrant, copying..."
  cp /vagrant/id_ed25519_gitlab_vagrant "${APP_HOME}/.ssh/id_ed25519"
  chmod 600 "${APP_HOME}/.ssh/id_ed25519"
  chown "${APP_USER}:${APP_USER}" "${APP_HOME}/.ssh/id_ed25519"
else
  echo "WARNING: no /vagrant/id_ed25519_gitlab_vagrant – git over SSH may fail."
fi

# Prepare known_hosts for gitlab.com for appuser
echo "=== 4.1) Preparing known_hosts for appuser ==="
sudo -u "${APP_USER}" env HOME="${APP_HOME}" bash -c '
  mkdir -p "$HOME/.ssh"
  touch "$HOME/.ssh/known_hosts"
  chmod 644 "$HOME/.ssh/known_hosts"
  if ! grep -q "gitlab.com" "$HOME/.ssh/known_hosts"; then
    ssh-keyscan gitlab.com >> "$HOME/.ssh/known_hosts" 2>/dev/null || true
  fi
'

echo "=== 5) Git + sparse-checkout PetClinic ==="
cd "${PROJECT_ROOT}"

if [ ! -d .git ]; then
  echo "Init git repo in ${PROJECT_ROOT}"
  sudo -u "${APP_USER}" git init
  sudo -u "${APP_USER}" git remote add origin "${GIT_URL}"
else
  echo "Git repo already exists in ${PROJECT_ROOT}"
fi

sudo -u "${APP_USER}" git config core.sparseCheckout true
SPARSE_FILE="${PROJECT_ROOT}/.git/info/sparse-checkout"
echo "${SPARSE_PATH}" | sudo -u "${APP_USER}" tee "${SPARSE_FILE}" >/dev/null

echo "Fetching branch ${GIT_BRANCH}..."
sudo -u "${APP_USER}" git fetch --depth=1 origin "${GIT_BRANCH}"

echo "Checking out ${GIT_BRANCH} with sparse path '${SPARSE_PATH}'..."
sudo -u "${APP_USER}" git checkout -t "origin/${GIT_BRANCH}" || \
sudo -u "${APP_USER}" git checkout "${GIT_BRANCH}"

if [ ! -d "${PROJECT_DIR}" ]; then
  echo "ERROR: ${PROJECT_DIR} not found after sparse-checkout!"
  exit 1
fi

chown -R "${APP_USER}:${APP_USER}" "${PROJECT_ROOT}"

echo "=== 6) Build PetClinic with Maven Wrapper ==="
cd "${PROJECT_DIR}"
chmod +x mvnw

sudo -u "${APP_USER}" bash -c "
  cd '${PROJECT_DIR}'
  ./mvnw -q test
  ./mvnw -q package
"

echo "=== 7) Copy built JAR to ${APP_DIR} ==="
ARTIFACT=$(sudo -u "${APP_USER}" bash -c "ls '${PROJECT_DIR}'/target/*.jar | head -n1")

if [ -z "${ARTIFACT}" ]; then
  echo 'ERROR: no JAR in target/.'
  exit 1
fi

cp "${ARTIFACT}" "${APP_DIR}/petclinic.jar"
chown "${APP_USER}:${APP_USER}" "${APP_DIR}/petclinic.jar"

echo "=== 8) Save DB_* env vars to /etc/profile.d/petclinic_env.sh ==="
cat >/etc/profile.d/petclinic_env.sh <<EOF
export DB_HOST='${DB_HOST}'
export DB_PORT='${DB_PORT}'
export DB_NAME='${DB_NAME}'
export DB_USER='${DB_USER}'
export DB_PASS='${DB_PASS}'
EOF

chmod +x /etc/profile.d/petclinic_env.sh

echo "=== 9) Start PetClinic as ${APP_USER} ==="
sudo -u "${APP_USER}" HOME="${APP_HOME}" bash -c '
  source /etc/profile.d/petclinic_env.sh

  JAR="$HOME/petclinic.jar"
  if [ ! -f "$JAR" ]; then
    echo "ERROR: $JAR not found!"
    exit 1
  fi

  echo "Running PetClinic..."
  nohup java -jar "$JAR" \
    --spring.profiles.active=mysql \
    --spring.datasource.url="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}" \
    --spring.datasource.username="${DB_USER}" \
    --spring.datasource.password="${DB_PASS}" \
    > "$HOME/app.log" 2>&1 &
'

echo "=== APP_VM provisioning done. PetClinic should be on http://APP_VM_IP:8080 ==="

