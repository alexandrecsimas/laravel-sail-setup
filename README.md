
# Projeto Laravel Sail Customizado

Este projeto contém um ambiente Laravel Sail customizado com Docker, scripts auxiliares e documentação para facilitar o desenvolvimento.

## Scripts principais

- `sail`: Script para gerenciar containers e comandos dentro do container Laravel Sail.
- `install-aliases`: Script para configurar aliases no shell para facilitar o uso do `sail`.

## Como começar

1. Configure seus aliases:

./install-aliases
source ~/.bashrc # ou ~/.zshrc conforme seu shell

text

2. Crie um novo projeto Laravel:

sail new

text

3. Suba os containers:

sail up -d

text

4. Use os comandos Laravel normalmente dentro do container via `sail`:

sail artisan migrate
sail composer install
sail npm run dev

text

## Documentação completa

Veja a documentação detalhada em [docs/index.md](docs/index.md) ou no site publicado via GitHub Pages.

---

