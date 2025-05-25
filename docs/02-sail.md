text
# Script `sail`

O script `sail` é o principal gerenciador do ambiente Laravel Sail customizado. Ele facilita a execução de comandos dentro do container Docker e o gerenciamento dos serviços.

## Comandos principais

- `sail up`: Sobe todos os containers.
- `sail down`: Para todos os containers.
- `sail new`: Cria um novo projeto Laravel, instala dependências, gera a chave e roda migrations automaticamente.
- Outros comandos Docker Compose: `stop`, `start`, `restart`, `logs`, `ps`.

## Comando `new`

O comando `new` realiza os seguintes passos:

1. Sobe os serviços essenciais `mysql` e `redis`.
2. Cria o projeto Laravel numa pasta temporária dentro do container.
3. Copia os arquivos para a raiz do projeto, ignorando arquivos e pastas Docker customizados.
4. Copia o arquivo de ambiente customizado `.env`.
5. Gera a chave da aplicação (`artisan key:generate`).
6. Instala dependências PHP (`composer install`) e JS (`npm install`).
7. Roda as migrations para preparar o banco de dados.
8. Remove a pasta temporária.

## Exemplos

Criar um novo projeto:

```shell
./sail new
```

Subir os containers:

```shell
./sail up -d
```

Executar comandos Artisan:

```shell
./sail artisan migrate
```

--- 

Para mais detalhes, veja o código fonte do script `sail`.

---

Para voltar ao menu principal, acesse [Início](HOME.md).
