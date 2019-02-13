#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR=${DIR}/app
MYSQL_ROOT_USERNAME=${MYSQL_ROOT_USERNAME:-admin}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-password}

log ()
{
        timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
        echo "[${timestamp}] $1"
}

init()
{
  local process_count=$(pgrep supervisord | wc -l)
  if [ ${process_count} -eq 0 ]; then
    log "Setting up services..."
    /run.sh & 2>&1
  fi
}

prepare_db()
{
  local mysql_cmd="mysql -u${MYSQL_ROOT_USERNAME} -p${MYSQL_ROOT_PASSWORD}"

  ${mysql_cmd} -e "status" > /dev/null 2>&1
  local mysql_exit_code=$?
  while [[ mysql_exit_code -ne 0 ]]; do
      sleep 2
      log "Waiting for confirmation of MySQL service startup"
      ${mysql_cmd} -e "status" > /dev/null 2>&1
      mysql_exit_code=$?
  done

  log "Preparing Database..."
  ${mysql_cmd} <<EOF
CREATE DATABASE IF NOT EXISTS demo DEFAULT CHARACTER SET utf8;
CREATE TABLE IF NOT EXISTS demo.employees (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    salary INT(10) NOT NULL
);
EOF

  log "Database setup complete"
}

prepare_app()
{
  if [ ! "/app/demo" -ef "/data/app" ]; then
    log "Setting up aplication..."
    ln -s /data/app /app/demo
    log "Application setup completed"
  fi
}

log "Running startup script..."
init
prepare_db
prepare_app
log "Application is running..."
