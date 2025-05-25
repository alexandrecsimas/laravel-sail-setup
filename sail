#!/usr/bin/env bash

DOCKER_COMPOSE="docker compose"
SERVICE="laravel.app"

function sail_exec() {
    $DOCKER_COMPOSE exec $SERVICE bash -c "$*"
}

if [ $# -eq 0 ]; then
    $DOCKER_COMPOSE up
else
    case "$1" in
        up|down|stop|start|restart|build|logs|ps)
            $DOCKER_COMPOSE "$@"
            ;;
        new)
            shift

            # Sobe apenas os serviços mysql e redis para garantir que o banco e cache estejam disponíveis
            $DOCKER_COMPOSE up -d mysql redis

            # Cria projeto Laravel numa pasta temporária dentro do container
            sail_exec "composer create-project laravel/laravel /tmp/.laravel-temp $*"

            # Copia arquivos do Laravel para a raiz, ignorando docker/, docker-compose*, sail, envs/
            sail_exec "rsync -av --exclude='docker' --exclude='docker-compose*' --exclude='sail' --exclude='envs' /tmp/.laravel-temp/ /var/www/html/"

            # Copia o arquivo de ambiente customizado para .env na raiz do projeto
            sail_exec "cp /var/www/html/envs/env.laravel /var/www/html/.env"

            # Gera a chave da aplicação Laravel automaticamente
            sail_exec "php /var/www/html/artisan key:generate"

            # Instala dependências PHP com Composer
            sail_exec "composer install --no-interaction --prefer-dist --optimize-autoloader"

            # Instala dependências JS com npm
            sail_exec "npm install"

            # Roda as migrations para criar as tabelas no banco de dados
            sail_exec "php /var/www/html/artisan migrate --force"

            # (Opcional) Roda os seeders para popular dados iniciais
            # sail_exec "php /var/www/html/artisan db:seed --force"

            # Remove pasta temporária
            sail_exec "rm -rf /tmp/.laravel-temp"
            ;;
    esac
fi
