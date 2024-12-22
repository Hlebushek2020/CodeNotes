#!/bin/bash

# vim: set expandtab ts=4 sw=4:

set -e

ask_parameters() {

  export PSONO_PROTOCOL="https://"
  export PSONO_VERSION=EE
  export PSONO_EXTERNAL_PORT=80
  export PSONO_EXTERNAL_PORT_SECURE=443
  export PSONO_POSTGRES_PORT=5432
  export PSONO_POSTGRES_PASSWORD=PSONO_IS_THE_BEST_OPEN_SOURCE_PASSWORD_MANAGER
  export PSONO_USERDOMAIN=localhost
  export PSONO_WEBDOMAIN=localhost
  export PSONO_POSTGRES_USER=postgres
  export PSONO_POSTGRES_DB=postgres
  export PSONO_POSTGRES_HOST=postgres
  export PSONO_INSTALL_ACME=0

  if [ -f "$HOME/.psonoenv" ]; then
    set -o allexport
    # shellcheck source=/dev/null
    source ~/.psonoenv
    set +o allexport
  fi

  echo "What version do you want to install? (Usually EE. Potential other choices are CE)"
  read -r -p "PSONO_VERSION [default: $PSONO_VERSION]: " PSONO_VERSION_NEW
  if [ "$PSONO_VERSION_NEW" != "" ]; then
    export PSONO_VERSION=$PSONO_VERSION_NEW
  fi

  if [[ ! $PSONO_VERSION =~ ^(EE|CE)$ ]]; then
    echo "unknown PSONO_VERSION: $PSONO_VERSION" >&2
    exit 1
  fi

  echo "What insecure external port do you want to use? (Usually port 80. Redirects http to https traffic.)"
  read -r -p "PSONO_EXTERNAL_PORT [default: $PSONO_EXTERNAL_PORT]: " PSONO_EXTERNAL_PORT_NEW
  if [ "$PSONO_EXTERNAL_PORT_NEW" != "" ]; then
    export PSONO_EXTERNAL_PORT=$PSONO_EXTERNAL_PORT_NEW
  fi

  echo "What secure external port do you want to use? (Usually port 443. The actual port serving all the traffic with https.)"
  read -r -p "PSONO_EXTERNAL_PORT_SECURE [default: $PSONO_EXTERNAL_PORT_SECURE]: " PSONO_EXTERNAL_PORT_SECURE_NEW
  if [ "$PSONO_EXTERNAL_PORT_SECURE_NEW" != "" ]; then
    export PSONO_EXTERNAL_PORT_SECURE=$PSONO_EXTERNAL_PORT_SECURE_NEW
  fi

  echo "What port do you want to use for the postgres? (Usually port 5432. Leave it to 5432 to use the dockered postgres)"
  read -r -p "PSONO_POSTGRES_PORT [default: $PSONO_POSTGRES_PORT]: " PSONO_POSTGRES_PORT_NEW
  if [ "$PSONO_POSTGRES_PORT_NEW" != "" ]; then
    export PSONO_POSTGRES_PORT=$PSONO_POSTGRES_PORT_NEW
  fi

  echo "What is the postgres DB user you want to use (Defaults to postgres)?"
  read -r -p "PSONO_POSTGRES_USER [default: $PSONO_POSTGRES_USER]: " PSONO_POSTGRES_USER_NEW
  if [ "$PSONO_POSTGRES_USER_NEW" != "" ]; then
    export PSONO_POSTGRES_USER=$PSONO_POSTGRES_USER_NEW
  fi

  echo "What is the postgres DB you want to use (Defaults to postgres)?"
  read -r -p "PSONO_POSTGRES_DB [default: $PSONO_POSTGRES_DB]: " PSONO_POSTGRES_DB_NEW
  if [ "$PSONO_POSTGRES_DB_NEW" != "" ]; then
    export PSONO_POSTGRES_DB=$PSONO_POSTGRES_DB_NEW
  fi

  echo "What is the postgres DB address (Leave it as 'postgres' if you want to use the dockered postgres DB)?"
  read -r -p "PSONO_POSTGRES_HOST [default: $PSONO_POSTGRES_HOST]: " PSONO_POSTGRES_HOST_NEW
  if [ "$PSONO_POSTGRES_HOST_NEW" != "" ]; then
    export PSONO_POSTGRES_HOST=$PSONO_POSTGRES_HOST_NEW
  fi

  if [ "$PSONO_POSTGRES_PASSWORD" == "PSONO_IS_THE_BEST_OPEN_SOURCE_PASSWORD_MANAGER" ]; then
    PSONO_POSTGRES_PASSWORD=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 32 | head -n 1)
    export PSONO_POSTGRES_PASSWORD
  fi
  echo "What password do you want to use for postgres?"
  read -r -p "PSONO_POSTGRES_PASSWORD [default: $PSONO_POSTGRES_PASSWORD]: " PSONO_POSTGRES_PASSWORD_NEW
  if [ "$PSONO_POSTGRES_PASSWORD_NEW" != "" ]; then
    export PSONO_POSTGRES_PASSWORD=$PSONO_POSTGRES_PASSWORD_NEW
  fi

  echo "What is the 'hostname' or 'domain' that you will use to access your installation?"
  read -r -p "PSONO_WEBDOMAIN [default: $PSONO_WEBDOMAIN]: " PSONO_WEBDOMAIN_NEW
  if [ "$PSONO_WEBDOMAIN_NEW" != "" ]; then
    export PSONO_WEBDOMAIN=$PSONO_WEBDOMAIN_NEW
  fi

  echo "What is the 'domain' that your usernames should end in?"
  read -r -p "PSONO_USERDOMAIN [default: $PSONO_USERDOMAIN]: " PSONO_USERDOMAIN_NEW
  if [ "$PSONO_USERDOMAIN_NEW" != "" ]; then
    export PSONO_USERDOMAIN=$PSONO_USERDOMAIN_NEW
  fi

  echo "Install ACME script? (This script requires that the server is publicly accessible under $PSONO_WEBDOMAIN_NEW"
  read -r -p "PSONO_INSTALL_ACME [default: $PSONO_INSTALL_ACME]: " PSONO_INSTALL_ACME_NEW
  if [ "$PSONO_INSTALL_ACME_NEW" != "" ]; then
    export PSONO_INSTALL_ACME=$PSONO_INSTALL_ACME_NEW
  fi

  rm -Rf ~/.psonoenv

  cat > ~/.psonoenv <<- "EOF"
PSONO_VERSION=PSONO_VERSION_VARIABLE
PSONO_EXTERNAL_PORT=PSONO_EXTERNAL_PORT_VARIABLE
PSONO_EXTERNAL_PORT_SECURE=PSONO_EXTERNAL_PORT_SECURE_VARIABLE
PSONO_POSTGRES_PORT=PSONO_POSTGRES_PORT_VARIABLE
PSONO_POSTGRES_PASSWORD=PSONO_POSTGRES_PASSWORD_VARIABLE
PSONO_USERDOMAIN=PSONO_USERDOMAIN_VARIABLE
PSONO_WEBDOMAIN=PSONO_WEBDOMAIN_VARIABLE
PSONO_POSTGRES_USER=PSONO_POSTGRES_USER_VARIABLE
PSONO_POSTGRES_DB=PSONO_POSTGRES_DB_VARIABLE
PSONO_POSTGRES_HOST=PSONO_POSTGRES_HOST_VARIABLE
EOF

  sed -i'' -e "s,PSONO_VERSION_VARIABLE,$PSONO_VERSION,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_EXTERNAL_PORT_SECURE_VARIABLE,$PSONO_EXTERNAL_PORT_SECURE,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_EXTERNAL_PORT_VARIABLE,$PSONO_EXTERNAL_PORT,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_POSTGRES_PORT_VARIABLE,$PSONO_POSTGRES_PORT,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_POSTGRES_PASSWORD_VARIABLE,$PSONO_POSTGRES_PASSWORD,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_USERDOMAIN_VARIABLE,$PSONO_USERDOMAIN,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_WEBDOMAIN_VARIABLE,$PSONO_WEBDOMAIN,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_POSTGRES_USER_VARIABLE,$PSONO_POSTGRES_USER,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_POSTGRES_DB_VARIABLE,$PSONO_POSTGRES_DB,g" ~/.psonoenv
  sed -i'' -e "s,PSONO_POSTGRES_HOST_VARIABLE,$PSONO_POSTGRES_HOST,g" ~/.psonoenv

  cp ~/.psonoenv ~/psono/psono-quickstart/.env
}


install_acme() {
    if [ "$PSONO_INSTALL_ACME" == "1" ]; then
        echo "Install acme.sh"

        mkdir -p ~/psono/html
        curl https://get.acme.sh | sh
        
        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        ~/.acme.sh/acme.sh --issue -d "$PSONO_WEBDOMAIN" -w ~/psono/html

        /root/.acme.sh/acme.sh --install-cert -d "$PSONO_WEBDOMAIN" \
          --key-file       ~/psono/certificates/private.key  \
          --fullchain-file ~/psono/certificates/public.crt \
          --reloadcmd     "cd /root/psono/psono-quickstart/ && $docker_compose_executable restart proxy"

        if ! crontab -l | grep "/root/.acme.sh/acme.sh --install-cert"; then
            crontab -l | {
              cat
              echo "0 */12 * * * /root/.acme.sh/acme.sh --install-cert -d $PSONO_WEBDOMAIN --key-file /root/psono/certificates/private.key --fullchain-file /root/psono/certificates/public.crt --reloadcmd \"cd /root/psono/psono-quickstart/ && $docker_compose_executable restart proxy\" > /dev/null"
            } | crontab -
        fi

        echo "Install acme.sh ... finished"
    fi
}


install_base_dependencies () {
    echo "Install curl and lsof"

    case "$OS" in
        ubuntu|debian)
            apt-get update &> /dev/null
            apt-get install -y curl lsof &> /dev/null
        ;;
        opensuse|suse)
            zypper ref &> /dev/null
            rpm -q curl &> /dev/null || zypper -n in curl &> /dev/null
            rpm -q lsof &> /dev/null || zypper -n in lsof &> /dev/null
        ;;
    esac

    echo "Install curl and lsof ... finished"
}


install_docker () {
    echo "Install docker"

    case "$OS" in
        ubuntu|debian)
            apt-get update &> /dev/null
            apt-get install -y docker.io &> /dev/null
        ;;
        opensuse|suse)
            zypper ref &> /dev/null
            zypper -n in docker &> /dev/null
            systemctl start docker &> /dev/null
            systemctl enable docker &> /dev/null
        ;;
    esac

    echo "Install docker ... finished"
}


install_docker_compose () {
    echo "Install docker-compose"

    case "$OS" in
        ubuntu|debian)
            apt-get update &> /dev/null
            apt-get install -y docker-compose &> /dev/null
        ;;
        opensuse|suse)
            zypper ref &> /dev/null
            zypper -n in docker-compose &> /dev/null
        ;;
    esac

    echo "Install docker ... finished"
}


install_docker_if_not_exists () {
    echo "Install docker if it is not already installed"

    set +e

    if which docker
    then
        set -e
        if docker --version | grep "Docker version"
        then
            echo "docker exists"
        else
            install_docker
        fi
    else
        install_docker
    fi
    echo "Install docker if it is not already installed ... finished"
}


install_docker_compose_if_not_exists () {
    echo "Install docker compose if it is not already installed"

    set +e

    if which docker-compose; then
        docker_compose_executable=$(which docker-compose)
        export docker_compose_executable
    else
        if docker compose version; then
            docker_compose_executable="$(which docker) compose"
            export docker_compose_executable
        else
            install_docker_compose
            docker_compose_executable=$(which docker-compose)
            export docker_compose_executable
        fi
   fi

    set -e

    echo "Install docker compose if it is not already installed ... finished"
}

craft_docker_compose_file () {
    echo "Crafting docker compose file"

    if [ "$PSONO_VERSION" == "EE" ]; then
        cat > ~/psono/psono-quickstart/docker-compose.yml <<- "EOF"
version: "2"
services:
  proxy:
    container_name: psono-quickstart-psono-proxy
    restart: always
    image: nginx:alpine
    ports:
      - "${PSONO_EXTERNAL_PORT}:80"
      - "${PSONO_EXTERNAL_PORT_SECURE}:443"
    depends_on:
      - psono-combo
      - psono-fileserver
    links:
      - psono-combo:psono-quickstart-psono-combo
      - psono-fileserver:psono-quickstart-psono-fileserver
    volumes:
      - ~/psono/html:/var/www/html
      - ~/psono/certificates/dhparam.pem:/etc/ssl/dhparam.pem
      - ~/psono/certificates/private.key:/etc/ssl/private.key
      - ~/psono/certificates/public.crt:/etc/ssl/public.crt
      - ~/psono/psono_nginx.conf:/etc/nginx/nginx.conf

  postgres:
    container_name: psono-quickstart-psono-postgres
    restart: always
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "${PSONO_POSTGRES_USER}"
      POSTGRES_PASSWORD: "${PSONO_POSTGRES_PASSWORD}"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/data/postgresql:/var/lib/postgresql/data

  psono-combo:
    container_name: psono-quickstart-psono-combo
    restart: always
    image: psono/psono-combo-enterprise:latest
    depends_on:
      - postgres
    links:
      - postgres:psono-quickstart-psono-postgres
    command: sh -c "sleep 10 && python3 psono/manage.py migrate && python3 psono/manage.py createuser admin@${PSONO_USERDOMAIN} admin admin@example.com && python3 psono/manage.py promoteuser admin@${PSONO_USERDOMAIN} superuser && python3 psono/manage.py createuser demo1@${PSONO_USERDOMAIN} demo1 demo1@example.com && python3 psono/manage.py createuser demo2@${PSONO_USERDOMAIN} demo2 demo2@example.com && /bin/sh /root/configs/docker/cmd.sh"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/config/settings.yaml:/root/.psono_server/settings.yaml
      - ~/psono/config/config.json:/usr/share/nginx/html/config.json
      - ~/psono/config/config.json:/usr/share/nginx/html/portal/config.json

  psono-fileserver:
    container_name: psono-quickstart-psono-fileserver
    restart: always
    image: psono/psono-fileserver:latest
    depends_on:
      - psono-combo
    links:
      - psono-combo:psono-quickstart-psono-combo
    command: sh -c "sleep 10 && /bin/sh /root/configs/docker/cmd.sh"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/data/shard:/opt/psono-shard
      - ~/psono/config/settings-fileserver.yaml:/root/.psono_fileserver/settings.yaml

  psono-watchtower:
    container_name: psono-quickstart-psono-watchtower
    restart: always
    image: containrrr/watchtower
    command: --label-enable --cleanup --interval 3600
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

EOF
    elif [ "$PSONO_VERSION" == "CE" ]; then
        cat > ~/psono/psono-quickstart/docker-compose.yml <<- "EOF"
version: "2"
services:
  proxy:
    container_name: psono-quickstart-psono-proxy
    restart: always
    image: nginx:alpine
    ports:
      - "${PSONO_EXTERNAL_PORT}:80"
      - "${PSONO_EXTERNAL_PORT_SECURE}:443"
    depends_on:
      - psono-combo
      - psono-fileserver
    links:
      - psono-combo:psono-quickstart-psono-combo
      - psono-fileserver:psono-quickstart-psono-fileserver
    volumes:
      - ~/psono/html:/var/www/html
      - ~/psono/certificates/dhparam.pem:/etc/ssl/dhparam.pem
      - ~/psono/certificates/private.key:/etc/ssl/private.key
      - ~/psono/certificates/public.crt:/etc/ssl/public.crt
      - ~/psono/psono_nginx.conf:/etc/nginx/nginx.conf

  postgres:
    container_name: psono-quickstart-psono-postgres
    restart: always
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "${PSONO_POSTGRES_USER}"
      POSTGRES_PASSWORD: "${PSONO_POSTGRES_PASSWORD}"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/data/postgresql:/var/lib/postgresql/data

  psono-combo:
    container_name: psono-quickstart-psono-combo
    restart: always
    image: psono/psono-combo:latest
    depends_on:
      - postgres
    links:
      - postgres:psono-quickstart-psono-postgres
    command: sh -c "sleep 10 && python3 psono/manage.py migrate && python3 psono/manage.py createuser admin@${PSONO_USERDOMAIN} admin admin@example.com && python3 psono/manage.py promoteuser admin@${PSONO_USERDOMAIN} superuser && python3 psono/manage.py createuser demo1@${PSONO_USERDOMAIN} demo1 demo1@example.com && python3 psono/manage.py createuser demo2@${PSONO_USERDOMAIN} demo2 demo2@example.com && /bin/sh /root/configs/docker/cmd.sh"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/config/settings.yaml:/root/.psono_server/settings.yaml
      - ~/psono/config/config.json:/usr/share/nginx/html/config.json
      - ~/psono/config/config.json:/usr/share/nginx/html/portal/config.json

  psono-fileserver:
    container_name: psono-quickstart-psono-fileserver
    restart: always
    image: psono/psono-fileserver:latest
    depends_on:
      - psono-combo
    links:
      - psono-combo:psono-quickstart-psono-combo
    command: sh -c "sleep 10 && /bin/sh /root/configs/docker/cmd.sh"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - ~/psono/data/shard:/opt/psono-shard
      - ~/psono/config/settings-fileserver.yaml:/root/.psono_fileserver/settings.yaml

  psono-watchtower:
    container_name: psono-quickstart-psono-watchtower
    restart: always
    image: containrrr/watchtower
    command: --label-enable --cleanup --interval 3600
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

EOF
    fi
    echo "Crafting docker compose file ... finished"
}


stop_container_if_running () {
    echo "Stopping docker containers"

    pushd ~/psono/psono-quickstart> /dev/null
    $docker_compose_executable stop
    popd> /dev/null
    echo "Stopping docker containers ... finished"
}


test_if_ports_are_free () {
    echo "Test for port availability"

    if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null ; then
        echo "Port 80 is occupied" >&2
        exit 1
    fi

    if lsof -Pi :443 -sTCP:LISTEN -t >/dev/null ; then
        echo "Port 443 is occupied" >&2
        exit 1
    fi

    echo "Test for port availability ... finished"
}


create_dhparam_if_not_exists() {
    echo "Create DH params if they dont exists"
    mkdir -p ~/psono/certificates

    if [ ! -f "$HOME/psono/certificates/dhparam.pem" ]; then
        openssl dhparam -dsaparam -out ~/psono/certificates/dhparam.pem 2048
    fi
    echo "Create DH params if they dont exists ... finished"
}


create_openssl_conf () {
    echo "Create openssl config"
    mkdir -p ~/psono/certificates
    rm -Rf ~/psono/certificates/openssl.conf
    cat > ~/psono/certificates/openssl.conf <<- "EOF"
[req]
default_bits       = 2048
default_keyfile    = ~/psono/certificates/private.key
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
countryName                 = Country Name (2 letter code)
countryName_default         = US
stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = New York
localityName                = Locality Name (eg, city)
localityName_default        = Rochester
organizationName            = Organization Name (eg, company)
organizationName_default    = Psono
organizationalUnitName      = organizationalunit
organizationalUnitName_default = Development
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_default          = PSONO_WEBDOMAIN
commonName_max              = 64

[req_ext]
subjectAltName = @alt_names

[v3_ca]
subjectAltName = @alt_names

[alt_names]
DNS.1   = PSONO_WEBDOMAIN
EOF
    sed -i'' -e "s,PSONO_WEBDOMAIN,$PSONO_WEBDOMAIN,g" ~/psono/certificates/openssl.conf
    echo "Create openssl config ... finished"
}

create_self_signed_certificate_if_not_exists () {
    echo "Create self signed certificate if it does not exist"
    mkdir -p ~/psono/certificates
    if [ ! -f "$HOME/psono/certificates/private.key" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/psono/certificates/private.key -out ~/psono/certificates/public.crt -config ~/psono/certificates/openssl.conf
    fi
    echo "Create self signed certificate if it does not exist ... finished"
}

create_config_json () {
    echo "Create config.json"
    mkdir -p ~/psono/config
    cat > ~/psono/config/config.json <<- "EOF"
{
  "backend_servers": [{
    "title": "Demo",
    "url": "PSONO_PROTOCOLPSONO_WEBDOMAIN/server",
    "domain": "PSONO_USERDOMAIN"
  }],
  "base_url": "PSONO_PROTOCOLPSONO_WEBDOMAIN/",
  "allow_custom_server": true
}
EOF
#    dns_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
#    if ifconfig | grep -q $dns_ip
#    then
#       public_url="htpp://$dns_ip:$PSONO_EXTERNAL_PORT";
#    else
#       public_url="$PSONO_PROTOCOL$PSONO_WEBDOMAIN";
#    fi
    sed -i'' -e "s,PSONO_PROTOCOL,$PSONO_PROTOCOL,g" ~/psono/config/config.json
    sed -i'' -e "s,PSONO_WEBDOMAIN,$PSONO_WEBDOMAIN,g" ~/psono/config/config.json
    sed -i'' -e "s,PSONO_USERDOMAIN,$PSONO_USERDOMAIN,g" ~/psono/config/config.json
    echo "Create config.json ... finished"
}

docker_compose_pull () {
    echo "Update docker images"

    pushd ~/psono/psono-quickstart> /dev/null

    $docker_compose_executable pull postgres
    $docker_compose_executable pull psono-combo
    $docker_compose_executable pull psono-fileserver
    $docker_compose_executable pull psono-watchtower

    popd> /dev/null
    echo "Update docker images ... finished"
}

create_settings_server_yaml () {
    echo "Create settings.yml for the server"
    mkdir -p ~/psono/config
    cat > ~/psono/config/settings.yaml <<- "EOF"

SECRET_KEY: 'SOME SUPER SECRET KEY THAT SHOULD BE RANDOM AND 32 OR MORE DIGITS LONG'
ACTIVATION_LINK_SECRET: 'SOME SUPER SECRET ACTIVATION LINK SECRET THAT SHOULD BE RANDOM AND 32 OR MORE DIGITS LONG'
DB_SECRET: 'SOME SUPER SECRET DB SECRET THAT SHOULD BE RANDOM AND 32 OR MORE DIGITS LONG'
EMAIL_SECRET_SALT: '$2b$12$XUG.sKxC2jmkUvWQjg53.e'
PRIVATE_KEY: '302650c3c82f7111c2e8ceb660d32173cdc8c3d7717f1d4f982aad5234648fcb'
PUBLIC_KEY: '02da2ad857321d701d754a7e60d0a147cdbc400ff4465e1f57bc2d9fbfeddf0b'

WEB_CLIENT_URL: 'http://example.com'

ALLOWED_HOSTS: ['*']
ALLOWED_DOMAINS: ['example.com']
HOST_URL: 'http://example.com/server'

# The email used to send emails, e.g. for activation
EMAIL_FROM: 'the-mail-for-for-example-useraccount-activations@test.com'
EMAIL_HOST: 'localhost'
EMAIL_HOST_USER: ''
EMAIL_HOST_PASSWORD : ''
EMAIL_PORT: 25
EMAIL_SUBJECT_PREFIX: ''
EMAIL_USE_TLS: False
EMAIL_USE_SSL: False
EMAIL_SSL_CERTFILE:
EMAIL_SSL_KEYFILE:
EMAIL_TIMEOUT:

EMAIL_BACKEND: 'django.core.mail.backends.smtp.EmailBackend'

MANAGEMENT_ENABLED: True

# Your Postgres Database credentials
DATABASES:
    default:
        'ENGINE': 'django.db.backends.postgresql_psycopg2'
        'NAME': 'YourPostgresDatabase'
        'USER': 'YourPostgresUser'
        'PASSWORD': 'YourPostgresPassword'
        'HOST': 'YourPostgresHost'
        'PORT': 'YourPostgresPort'

# Your path to your templates folder
TEMPLATES: [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': ['/root/psono/templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

EOF

    sed -i'' -e "s,WEB_CLIENT_URL: 'http://example.com',WEB_CLIENT_URL: '$PSONO_PROTOCOL$PSONO_WEBDOMAIN',g" ~/psono/config/settings.yaml
    sed -i'' -e "s,HOST_URL: 'http://example.com/server',HOST_URL: '$PSONO_PROTOCOL$PSONO_WEBDOMAIN/server',g" ~/psono/config/settings.yaml
    sed -i'' -e "s,ALLOWED_DOMAINS: \['example.com'],ALLOWED_DOMAINS: ['$PSONO_USERDOMAIN'],g" ~/psono/config/settings.yaml
    sed -i'' -e "s,EMAIL_HOST: 'localhost',EMAIL_HOST: 'mail',g" ~/psono/config/settings.yaml
    sed -i'' -e "s,YourPostgresDatabase,$PSONO_POSTGRES_DB,g" ~/psono/config/settings.yaml
    sed -i'' -e "s,YourPostgresUser,$PSONO_POSTGRES_USER,g" ~/psono/config/settings.yaml
    sed -i'' -e "s,YourPostgresPassword,$PSONO_POSTGRES_PASSWORD,g" ~/psono/config/settings.yaml
    sed -i'' -e "s,YourPostgresHost,$PSONO_POSTGRES_HOST,g" ~/psono/config/settings.yaml
    sed -i'' -e "s,YourPostgresPort,$PSONO_POSTGRES_PORT,g" ~/psono/config/settings.yaml

    pushd ~/psono/psono-quickstart> /dev/null
    $docker_compose_executable run psono-combo /bin/sh -c "sleep 20 && python3 psono/manage.py migrate"
    if [ ! -f ~/.psono_server_keys ]; then
        $docker_compose_executable run psono-combo /bin/sh -c "sleep 20 && python3 psono/manage.py generateserverkeys" > ~/.psono_server_keys
    fi
    popd> /dev/null

    sed -i '/^SECRET_KEY:/d' "${HOME}/psono/config/settings.yaml"
    sed -i '/^ACTIVATION_LINK_SECRET:/d' "${HOME}/psono/config/settings.yaml"
    sed -i '/^DB_SECRET:/d' "${HOME}/psono/config/settings.yaml"
    sed -i '/^EMAIL_SECRET_SALT:/d' "${HOME}/psono/config/settings.yaml"
    sed -i '/^PRIVATE_KEY:/d' "${HOME}/psono/config/settings.yaml"
    sed -i '/^PUBLIC_KEY:/d' "${HOME}/psono/config/settings.yaml"

    echo -e "$(cat ~/.psono_server_keys)\n$(cat "${HOME}/psono/config/settings.yaml")" > "${HOME}/psono/config/settings.yaml"
    echo "Create settings.yml for the server ... finished"
}

create_settings_fileserver_yaml () {
    echo "Create settings.yml for the fileserver"
    mkdir -p ~/psono/config
    cat > ~/psono/config/settings-fileserver.yaml <<- "EOF"

SERVER_URL: 'https://example.com/server'
ALLOWED_HOSTS: ['*']
HOST_URL: 'https://example.com/fileserver01'

EOF

    sed -i'' -e "s,SERVER_URL: 'https://example.com/server',SERVER_URL: 'http://psono-combo/server',g" ~/psono/config/settings-fileserver.yaml
    sed -i'' -e "s,HOST_URL: 'https://example.com/fileserver01',HOST_URL: '$PSONO_PROTOCOL$PSONO_WEBDOMAIN/fileserver',g" ~/psono/config/settings-fileserver.yaml

    pushd ~/psono/psono-quickstart> /dev/null
    $docker_compose_executable run psono-combo /bin/sh -c "sleep 20 && python3 psono/manage.py fsclustercreate 'Test Cluster' --fix-cluster-id=d5d8fea5-3c9c-4a3c-97db-8d50dd2f473c && python3 psono/manage.py fsshardcreate 'Test Shard' 'Test Shard Description' --fix-shard-id=5575b1a3-0d99-41bb-aa76-8277236ba90b && python3 psono/manage.py fsshardlink d5d8fea5-3c9c-4a3c-97db-8d50dd2f473c 5575b1a3-0d99-41bb-aa76-8277236ba90b  --fix-link-id=324ebf85-09fe-4172-87c6-09fdf7a7c108"
    $docker_compose_executable run psono-combo /bin/sh -c "sleep 20 && python3 psono/manage.py fsclustershowconfig d5d8fea5-3c9c-4a3c-97db-8d50dd2f473c" > ~/.psono_fileserver_server_keys
    popd> /dev/null

    sed -i '/^SERVER_URL:/d' ~/.psono_fileserver_server_keys

    echo -e "$(cat ~/.psono_fileserver_server_keys)\n$(cat "${HOME}/psono/config/settings-fileserver.yaml")" > "${HOME}/psono/config/settings-fileserver.yaml"

    rm  ~/.psono_fileserver_server_keys
    echo "Create settings.yml for the fileserver ... finished"
}

build_psono_proxy_configuration () {
    echo "Build psono proxy configuration"
    cat > ~/psono/psono_nginx.conf <<- "EOF"
worker_processes 1;

events { worker_connections 1024; }

http {

    sendfile on;

    server {
        listen 80;
        server_name _;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl http2;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_dhparam /etc/ssl/dhparam.pem;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;
        ssl_session_tickets off;
        ssl_stapling on;
        ssl_stapling_verify on;
        ssl_session_timeout 1d;
        resolver 8.8.8.8 8.8.4.4 valid=300s;
        resolver_timeout 5s;
        ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';

        # add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";

        add_header Referrer-Policy same-origin;
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Content-Security-Policy "default-src 'none'; manifest-src 'self'; connect-src 'self' https://static.psono.com https://storage.googleapis.com https://*.s3.amazonaws.com https://*.digitaloceanspaces.com https://api.pwnedpasswords.com; font-src 'self'; img-src 'self' www.google-analytics.com data:; script-src 'self' www.google-analytics.com; style-src 'self' 'unsafe-inline'; object-src 'self'; form-action 'self'";

        ssl_certificate /etc/ssl/public.crt;
        ssl_certificate_key /etc/ssl/private.key;

        gzip on;
        gzip_disable "msie6";

        gzip_vary on;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_buffers 16 8k;
        gzip_http_version 1.1;
        gzip_min_length 256;
        gzip_types text/plain text/css application/json application/x-javascript application/javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

        client_max_body_size 200m;

        root /var/www/html;
        location ~ /.well-known {
            allow all;
        }

        location /fileserver {
            rewrite ^/fileserver/(.*) /$1 break;
            proxy_set_header        Host $host;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;

            proxy_pass              http://psono-fileserver:80;
        }

        location / {
            proxy_set_header        Host $host;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;

            proxy_pass              http://psono-combo:80;
            proxy_read_timeout      90;

            proxy_redirect          http://psono-combo:80 /;
        }
    }

}

EOF
    echo "Build psono proxy configuration ... finished"
}

start_stack () {
    echo "Start the stack"

    pushd ~/psono/psono-quickstart> /dev/null

    $docker_compose_executable up -d

    popd> /dev/null

    echo "Start the stack ... finished"
}

install_alias () {
    echo "Install alias"

    if [ ! -f ~/.bash_aliases ]; then
        touch ~/.bash_aliases
    fi

    sed -i '/^alias psonoctl=/d' ~/.bash_aliases

    alias psonoctl="cd ~/psono/psono-quickstart && $docker_compose_executable"
    echo -e "alias psonoctl='cd ~/psono/psono-quickstart && $docker_compose_executable'\n$(cat ~/.bash_aliases)" > ~/.bash_aliases

    echo "Install alias ... finished"
}

detect_os () {
    echo "Start detect OS"
    if which lsb_release 2>/dev/null; then
        DIST=$(lsb_release -c | cut -f2)
        VERSION=$(lsb_release -r | cut -f2)
        OS=$(lsb_release -i | cut -f2 | awk '{ print tolower($1) }')
        export OS
    else
        echo "Unknown OS" >&2
        exit 1
    fi
    case "$OS" in
        ubuntu|debian)
            echo "Detected $OS: $DIST"
        ;;

        opensuse|suse)
            echo "Detected $OS: $VERSION"
        ;;

        *)
            echo "Unsupported OS" >&2
            exit 1
        ;;
    esac

    echo "Start detect OS ... finished"
}

main() {

    detect_os

    install_base_dependencies

    mkdir -p ~/psono
    rm -Rf ~/psono/psono-quickstart
    mkdir -p ~/psono/psono-quickstart

    install_docker_if_not_exists

    install_docker_compose_if_not_exists

    ask_parameters

    craft_docker_compose_file

    stop_container_if_running

    test_if_ports_are_free

    mkdir -p ~/psono/html
    mkdir -p ~/psono/data/postgresql
    mkdir -p ~/psono/data/mail
    mkdir -p ~/psono/data/shard

    create_dhparam_if_not_exists

    create_openssl_conf

    create_self_signed_certificate_if_not_exists

    create_config_json

    docker_compose_pull

    create_settings_server_yaml

    create_settings_fileserver_yaml

    build_psono_proxy_configuration

    start_stack

    install_acme

    install_alias

    echo ""
    echo "========================="
    echo "CLIENT URL : https://$PSONO_WEBDOMAIN"
    echo "ADMIN URL : https://$PSONO_WEBDOMAIN/portal/"
    echo ""
    echo "USER1: demo1@$PSONO_USERDOMAIN"
    echo "PASSWORD: demo1"
    echo ""
    echo "USER2: demo2@$PSONO_USERDOMAIN"
    echo "PASS: demo2"
    echo ""
    echo "ADMIN: admin@$PSONO_USERDOMAIN"
    echo "PASS: admin"
    echo "========================="
    echo ""
}

main
