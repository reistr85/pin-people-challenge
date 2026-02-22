# Pin People – API

API REST em Rails da aplicação Pin People: gestão de clientes, colaboradores, enquetes e importação em massa via CSV.

---

## Tecnologias

| Camada | Tecnologia |
|--------|------------|
| **Linguagem** | Ruby 3.2.2 |
| **Framework** | Rails 8.1 |
| **Banco de dados** | PostgreSQL (pg) |
| **API** | JSON (Jbuilder), Rack CORS |
| **Autenticação** | Devise (token na API) |
| **Servidor HTTP** | Puma + Thruster (cache/compressão) |
| **Filas** | Sidekiq + Redis (Active Job) |
| **Cache / adapters** | Solid Cache, Solid Queue, Solid Cable |
| **Paginação** | Kaminari |
| **Upload CSV (produção)** | AWS S3 (aws-sdk-s3) |
| **Imagens** | Image Processing, Vips |
| **Testes** | Minitest (Rails), testes de integração (controllers) |
| **Container** | Docker (multi-stage), imagem slim |

### Principais gems

- **devise** – autenticação (login por email/senha, token para API)
- **sidekiq** – jobs em background (ex.: processamento do CSV após upload)
- **jbuilder** – serialização JSON das respostas
- **kaminari** – paginação (ex.: listagem de colaboradores)
- **rack-cors** – CORS para consumo pelo frontend
- **dotenv-rails** – variáveis de ambiente a partir do `.env` (dev/test)
- **aws-sdk-s3** – upload/download de arquivos no S3 (importação CSV)

---

## Serviços AWS e infraestrutura

Serviços utilizados em produção para hospedagem, storage e rede:

| Logo | Serviço | Descrição |
|------|---------|-----------|
| <img src="https://cdn.simpleicons.org/amazonaws/232F3E" width="24" height="24" alt="AWS" /> | **Amazon ECR** | Registry de imagens Docker. O build da API é enviado ao ECR e o Kubernetes (K3s) faz pull da imagem para os pods. |
| <img src="https://cdn.simpleicons.org/amazons3/569A31" width="24" height="24" alt="S3" /> | **Amazon S3** | Bucket para armazenar os arquivos CSV da importação. O upload é feito pela API e o job Sidekiq processa o arquivo a partir do S3. |
| <img src="https://cdn.simpleicons.org/cloudflare/F38020" width="24" height="24" alt="Cloudflare" /> | **Cloudflare** | DNS, proxy reverso e proteção (DDoS, WAF). O tráfego para a API pode passar pelo Cloudflare antes de chegar ao cluster. |
| <img src="https://cdn.simpleicons.org/traefikproxy/24E1B4" width="24" height="24" alt="Traefik" /> | **Certificado SSL / Traefik** | Terminação TLS e emissão/renovação de certificados (ex.: Let's Encrypt) no cluster, via Ingress e Traefik ou similar. |

---

## Rodar o projeto localmente

### Pré-requisitos

- Ruby 3.2.2 (recomendado: rbenv ou asdf)
- PostgreSQL
- Redis 7+ (Sidekiq 8 exige Redis 7)
- Bundler 2.5+

### Opção 1: Docker Compose (recomendado)

```bash
# Subir PostgreSQL, Redis, Rails e Sidekiq
docker compose up -d

# A API fica em http://localhost:3000
# Criar banco e tabelas (se necessário)
docker compose exec rails bin/rails db:prepare
```

Serviços:

- **rails** – API na porta 3000
- **sidekiq** – processamento de jobs (ex.: importação CSV)
- **postgres** – porta 5432
- **redis** – porta 6379

### Opção 2: Ruby local

1. Clone o repositório e entre na pasta do projeto (API).

2. Instale dependências:
   ```bash
   bundle install
   ```

3. Configure o ambiente (opcional para dev):
   ```bash
   cp .env.example .env
   # Ajuste .env se precisar (DATABASE_URL, REDIS_URL, S3, etc.)
   ```

4. Banco de dados:
   ```bash
   bin/rails db:create db:migrate
   # Ou apenas: bin/rails db:prepare
   ```

5. Suba PostgreSQL e Redis (localmente ou via Docker só para postgres/redis).

6. Inicie a API e o Sidekiq em terminais separados:
   ```bash
   # Terminal 1
   bin/rails server

   # Terminal 2
   bundle exec sidekiq
   ```

A API estará em `http://localhost:3000`. Endpoints principais: `/api/v1/health`, `/api/v1/auth/sign_in`, `/api/v1/clients`, etc.

### Variáveis de ambiente (dev/test)

No `.env` (copiado de `.env.example`):

- **DATABASE_URL** – conexão Postgres (ex.: `postgres://challenge:challenge@localhost:5432/challenge_development`)
- **REDIS_URL** – conexão Redis (ex.: `redis://localhost:6379/0`)
- **S3 (opcional)** – se definir `S3_IMPORT_BUCKET`, `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, a importação CSV usa S3; caso contrário, usa `storage/` local.

---

## Infraestrutura em produção

A API roda em **Kubernetes (K3s)** em uma VPS. Resumo dos recursos no namespace `pin-people`:

| Recurso | Descrição |
|---------|-----------|
| **pin-people-deployment** | Pod(s) da API Rails (Puma + Thruster), porta 80 |
| **pin-people-sidekiq** | Pod(s) do Sidekiq (processamento de jobs, ex.: CSV) |
| **redis-deployment** | Redis 7 (filas Sidekiq, cache) |
| **redis-service** | Serviço ClusterIP para o Redis |
| **pin-people-configmap-env** | ConfigMap com variáveis (RAILS_ENV, DATABASE_URL, REDIS_URL, S3, etc.) |
| **ecr-credentials** | Secret para pull da imagem no Amazon ECR |
| **Service** | Expõe a API (ClusterIP/NodePort conforme config) |
| **Ingress** | Roteamento HTTP/HTTPS para a API (host configurável) |
| **PersistentVolumeClaim** | Para arquivos públicos, se necessário |

Fluxo de tráfego: **Internet → Ingress → Service → pin-people-deployment**. O Sidekiq consome jobs do Redis; a API enfileira jobs (ex.: após upload do CSV para o S3).

Banco de dados em produção é um **PostgreSQL externo** (não está no cluster); a conexão é feita via `DATABASE_URL` no ConfigMap.

---

## Processo de deploy

O deploy é feito pelo **GitHub Actions** no push para a branch `main`.

### Pipeline (`.github/workflows/production.yml`)

1. **Job `test`**
   - Checkout do código
   - Ruby 3.2.2 + Bundler (cache)
   - PostgreSQL 15 como serviço
   - `rails db:schema:load` e `rails test`
   - Se os testes falharem, o deploy não é executado

2. **Job `build-and-deploy`** (depende de `test`)
   - Checkout
   - Login no **Amazon ECR**
   - **Build** da imagem Docker (Dockerfile do projeto) e **push** para ECR (`$IMAGE_TAG` = SHA do commit e `latest`)
   - **Atualização dos manifests** em `k8s/`: substituição de placeholders (imagem, RAILS_MASTER_KEY, DATABASE_URL, variáveis S3, host do Ingress, etc.)
   - **SSH** na VPS (K3s)
   - Cópia dos arquivos de `k8s/` para a VPS
   - Criação/atualização do **secret** `ecr-credentials` para o cluster puxar a imagem do ECR
   - **kubectl apply** dos manifests (ConfigMap, Redis, Deployment da API, Sidekiq, Service, Ingress, etc.)
   - **Rollout restart** dos deployments da API e do Sidekiq
   - Aguarda o status do rollout

### Secrets / variáveis necessários no repositório

- **K8S_DOCKER_REPOSITORY** – repositório ECR (ex.: `123456789.dkr.ecr.us-east-1.amazonaws.com/pin-people`)
- **K8S_IMAGE_NAME** – nome da imagem (ex.: `api`)
- **K8S_K3S_SERVER** – IP ou hostname da VPS
- **K8S_K3S_USER** – usuário SSH
- **K8S_SSH_PRIVATE_KEY** – chave SSH
- **K8S_AWS_ACCESS_KEY_ID**, **K8S_AWS_SECRET_ACCESS_KEY**, **K8S_AWS_REGION** – credenciais AWS (ECR)
- **RAILS_MASTER_KEY** – conteúdo de `config/master.key`
- **DATABASE_URL** (ou uso no workflow) – conexão do Postgres de produção
- **INGRESS_HOST** (opcional) – host do Ingress
- **S3** (opcional): **S3_IMPORT_BUCKET**, **AWS_REGION**, **S3_IMPORT_AWS_ACCESS_KEY_ID**, **S3_IMPORT_AWS_SECRET_ACCESS_KEY** – para importação CSV via S3

### Deploy manual (sem CI)

Se for aplicar os manifests à mão na VPS:

1. Build e push da imagem para o ECR.
2. No servidor com `kubectl` configurado para o cluster:
   - Ajustar os YAMLs em `k8s/` com a imagem e as variáveis corretas.
   - `kubectl apply -f k8s/` (ou aplicar arquivo por arquivo).
   - `kubectl rollout restart deployment/pin-people-deployment deployment/pin-people-sidekiq -n pin-people`.

---

## Endpoints principais

| Método | Caminho | Descrição |
|--------|---------|-----------|
| GET | `/api/v1/health` | Health check |
| GET | `/api/v1/ready` | Readiness |
| POST | `/api/v1/auth/sign_in` | Login (retorna token) |
| DELETE | `/api/v1/auth/sign_out` | Logout |
| GET | `/api/v1/auth/me` | Usuário atual (token) |
| GET/POST | `/api/v1/clients` | Listar/criar clientes |
| GET/PUT/DELETE | `/api/v1/clients/:uuid` | Cliente por UUID |
| GET/POST | `/api/v1/employees` | Listar/criar colaboradores |
| GET/PUT/DELETE | `/api/v1/employees/:uuid` | Colaborador por UUID |
| GET/POST | `/api/v1/surveys` | Listar/criar enquetes |
| GET/PUT/DELETE | `/api/v1/surveys/:uuid` | Enquete por UUID |
| PUT | `/api/v1/surveys/:uuid/responses` | Colaborador: enviar respostas da enquete |
| POST | `/api/v1/imports/csv` | Importação CSV (admin/cliente; opcional S3) |

Autenticação: header `Authorization: Bearer <token>` (token retornado no `sign_in`).

---

## Testes

```bash
# Todos os testes
bundle exec rails test

# Apenas models
bundle exec rails test test/models

# Apenas controllers (integração)
bundle exec rails test test/controllers
```

Requer PostgreSQL e Redis para os testes que usam Sidekiq/Redis (o CI sobe Postgres como serviço e define `DATABASE_URL`).

---

## Licença

Conforme definido no repositório do projeto.
