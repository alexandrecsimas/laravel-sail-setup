#!/usr/bin/env bash

DOCKER_COMPOSE="docker compose"
SERVICE="laravel.app"

# Função para obter UID:GID do usuário atual
function get_current_ids() {
    echo "$(id -u):$(id -g)"
}

function inject_env_ids() {
    local env_file="${1:-.env}"
    if [ -f "$env_file" ]; then
        ids=$(get_current_ids)
        sed -i "s/^WWWGROUP=.*/WWWGROUP=${ids#*:}/" "$env_file"
        sed -i "s/^WWWUSER=.*/WWWUSER=${ids%:*}/" "$env_file"
    fi
}

# Função para garantir que .env existe e está configurado corretamente
function ensure_env_file() {
    if [ ! -f .env ]; then
        echo "Criando .env a partir do template..."
        cp envs/env.laravel .env
        inject_env_ids .env
        chmod 644 .env
        echo "✓ .env criado com seus IDs (UID:$(id -u), GID:$(id -g))"
    elif grep -q '^WWWGROUP=$' .env || grep -q '^WWWUSER=$' .env; then
        inject_env_ids .env
        echo "✓ IDs injetados no .env existente"
    fi
}

# Função para executar comandos no container
function sail_exec() {
    $DOCKER_COMPOSE exec -u sail $SERVICE bash -c "$*"
}

# Verifica e configura o ambiente antes de qualquer operação
ensure_env_file

# Carrega variáveis do .env
export $(grep -v '^#' .env | xargs)

if [ $# -eq 0 ]; then
    $DOCKER_COMPOSE up
else
    case "$1" in
        up|down|stop|start|restart|build|logs|ps|pull|rm)
            $DOCKER_COMPOSE "$@"
            ;;
        new)
            shift

            echo "Iniciando criação do projeto Laravel..."

            # Sobe serviços essenciais em segundo plano
            $DOCKER_COMPOSE up -d mysql redis

            # Cria projeto Laravel temporário
            sail_exec "composer create-project laravel/laravel /tmp/.laravel-temp $*"

            # Copia arquivos excluindo configurações do Sail
            sail_exec "rsync -av --exclude='docker' --exclude='docker-compose*' --exclude='sail' --exclude='envs' /tmp/.laravel-temp/ /var/www/html/"

            # Garante que o .env correto está no lugar
            cp .env /var/www/html/.env 2>/dev/null || true

            # Configurações pós-instalação
            sail_exec "
                composer install --no-interaction --prefer-dist --optimize-autoloader &&
                npm install &&
                php artisan key:generate &&
                php artisan storage:link
            "

            # Migração do banco de dados (opcional)
            read -p "Deseja executar as migrations? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sail_exec "php artisan migrate --force"
            fi

            # Limpeza
            sail_exec "rm -rf /tmp/.laravel-temp"
            $DOCKER_COMPOSE down

            echo "Projeto Laravel criado com sucesso!"
            echo "Execute './sail up -d' para iniciar os serviços."
            ;;
        shell|bash)
            $DOCKER_COMPOSE exec -u sail $SERVICE bash
            ;;
        root-shell)
            $DOCKER_COMPOSE exec $SERVICE bash
            ;;
        composer|artisan|node|npm|npx|yarn|php)
            shift
            sail_exec "$(basename $0) $*"
            ;;
        *)
            echo "Comandos disponíveis:"
            echo "  up, down, stop, start, restart, build, logs, ps, pull, rm"
            echo "  new [opções]      - Cria novo projeto Laravel"
            echo "  shell|bash        - Acessa o container como usuário sail"
            echo "  root-shell       - Acessa o container como root"
            echo "  composer [cmd]    - Executa comandos do Composer"
            echo "  artisan [cmd]     - Executa comandos do Artisan"
            echo "  npm|node|npx [cmd] - Executa comandos do Node"
            echo "  php [cmd]         - Executa comandos PHP"
            ;;
    esac
fi