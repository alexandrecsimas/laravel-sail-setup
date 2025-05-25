# Docker e docker-compose

Este documento detalha a configuração do Dockerfile, docker-compose.yml e scripts auxiliares usados no projeto.

## Dockerfile

- Baseado em Ubuntu 22.04.
- Instala PHP 8.4 com extensões necessárias para Laravel.
- Instala Node.js 20 e Yarn.
- Configura usuário `sail` com UID e GID parametrizados.
- Permite que PHP escute em portas privilegiadas.
- Limpeza para manter imagem enxuta.

## docker-compose.yml

- Serviços:
    - `laravel.app`: container da aplicação Laravel.
    - `mysql`: banco de dados MySQL.
    - `redis`: cache Redis.
- Volumes para persistência de dados e caches:
    - `sailmysql` para MySQL.
    - `sailredis` para Redis.
    - `sail_composer_cache` para cache do Composer.
    - `sail_sail_cache` para cache do Sail.
- Rede personalizada `sail`.

## start-container

- Script de inicialização do container.
- Ajusta permissões e usuários.
- Inicializa o Supervisor para rodar o servidor Laravel embutido.

## supervisord.conf

- Configura o Supervisor para rodar o servidor Laravel na porta 80.
- Logs direcionados para stdout e stderr para integração com Docker.

---

Para mais detalhes, veja os arquivos na pasta `docker/`.

---

Para voltar ao menu principal, acesse [Início](01-HOME.md).
