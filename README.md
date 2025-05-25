
# Projeto Laravel Sail Customizado

Este projeto contém um ambiente Laravel Sail customizado com Docker, scripts auxiliares e documentação para facilitar o desenvolvimento.

## Scripts principais

- `sail`: Script para gerenciar containers e comandos dentro do container Laravel Sail.
- `install-aliases`: Script para configurar aliases no shell para facilitar o uso do `sail`.

## Como começar

1. Configure seus aliases:

```shell
./install-aliases
source ~/.bashrc # ou ~/.zshrc conforme seu shell
```


2. Crie um novo projeto Laravel:

```shell
sail new
``` 

3. Suba os containers:

```shell
sail up -d
```

4. Use os comandos Laravel normalmente dentro do container via `sail`:

```shell
sail artisan migrate
sail composer install
sail npm run dev
``` 


## Documentação completa

Veja a documentação detalhada [AQUI](docs/HOME.md) ou no site publicado via GitHub Pages.

---

