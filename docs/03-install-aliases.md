# Script `install-aliases`

Este script configura aliases no seu shell (bash ou zsh) para facilitar o uso do script `sail`.

## O que faz

- Detecta seu shell atual (`bash` ou `zsh`).
- Verifica o arquivo de configuração correspondente (`.bashrc` ou `.zshrc`).
- Adiciona aliases para os comandos `sail` e `sail new`, se ainda não estiverem configurados.
- Evita duplicidade removendo definições antigas.
- Informa para reiniciar o terminal ou rodar `source` no arquivo de configuração.

## Como usar

1. Dê permissão de execução:

```shell
chmod +x install-aliases
```

2. Execute o script:

```shell
./install-aliases
```

3. Reinicie seu terminal ou rode:

```shell
source ~/.bashrc # ou ~/.zshrc, conforme seu shell
```

## Como adicionar novos aliases

Edite o array `aliases` dentro do script para incluir novos comandos.

---

Para mais detalhes, veja o código fonte do script `install-aliases`.

---

Para voltar ao menu principal, acesse [Início](01-HOME.md).

