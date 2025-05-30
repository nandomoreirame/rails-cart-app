# Rails Cart App

## Requisitos

- **Ruby**: 3.3 (gerenciado via [mise](https://mise.jdx.dev/))
- **Ruby on Rails**: 7.1.5.1
- **PostgreSQL**: recomendado 15 ou superior (o container oficial do Docker será utilizado)
- **Docker**: para subir o banco de dados
- **Bundler**: para instalar as gems

## Configuração do Ambiente

1. **Instale o [mise](https://mise.jdx.dev/):**
   - Siga as instruções do site oficial para instalar o mise em seu sistema.

2. **Instale o Ruby na versão correta:**
   ```bash
   mise use ruby@3.3
   ```

3. **Instale as dependências do projeto:**
   ```bash
   cd cart-app
   bundle install
   ```

4. **Configure as variáveis de ambiente:**
   - Copie o arquivo `.env.sample` para `./cart-app/.env` e ajuste os valores conforme necessário (nome do app, usuário e senha do banco, etc).

## Subindo o Banco de Dados (Postgres) com Docker

O projeto já possui scripts para facilitar o uso do banco de dados via Docker.

- **Para iniciar o banco de dados:**
  ```bash
  ./docker-run.sh
  ```

- **Para parar o banco de dados:**
  ```bash
  ./docker-stop.sh
  ```

Esses scripts utilizam as variáveis de ambiente definidas no `.env` para configurar o container do Postgres.

## Inicializando o Projeto

Você pode usar o script `start.sh` para automatizar o processo de inicialização do ambiente e do servidor Rails:

```bash
./start.sh
```

Esse script irá:
- Subir o banco de dados Postgres via Docker (caso não esteja rodando)
- Instalar as dependências Ruby
- Executar as migrações e seeds do banco
- Iniciar o servidor Rails na porta 3000

## Observações

- O banco de dados é isolado em um container Docker, facilitando o setup e evitando conflitos locais.
- Certifique-se de que as portas 3000 (Rails) e 5432 (Postgres) estejam livres em sua máquina.
- Certifique também se o Docker está rodando em sua máquina antes de executar o os scripts (.sh) do projeto.

