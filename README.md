# 📊 Purchase Effort Comparator — Data Collector (TCC)

> **Trabalho de Conclusão de Curso (MBA em Engenharia de Software)**  
> **Autor:** Caio de Luccas Rosolen  
> **Orientador:** Prof. Dr. Mauricio Acconcia Dias  
> **Acesse o Sistema / Live System:** [esforcodecompra.com.br](https://esforcodecompra.com.br/)

---

🌐 **Language / Idioma:** [English](#-english) | 🇧🇷 [Português](#-português)

---

## 🌐 English

Automatically collecting product prices and wage indicators via public APIs, and calculating metrics such as income commitment percentage and the working hours required to purchase the same product across different countries.

### 📌 Problem Statement

- The nominal value of money does not necessarily reflect local consumption capacity.
- Economic data (prices and wages) remains scattered across disparate sources with heterogeneous formats.
- There is a lack of automated tools capable of integrating and processing this data in a comparable manner.

### 🎯 Project Objective

Develop a web system capable of:

- ✅ Automatically collecting product prices
- ✅ Integrating wage and labor indicators
- ✅ Persisting historical series data
- ✅ Processing comparative metrics on-demand
- ✅ Exposing results via a REST API and Frontend interface

### 🏗️ System Architecture

A modular architecture inspired by microservices, featuring components isolated within Docker containers and standardized communication via a REST API.

```
                ┌────────────────────────┐      ┌────────────────────────┐
                │       Canopy API       │      │      ILOSTAT API       │
                │    (Product Prices)    │      │   (Labor Indicators)   │
                └───────────┬────────────┘      └───────────┬────────────┘
                            │ (JSON)                        │ (JSON)
                            └───────────────┬───────────────┘
                                            ▼
                                ┌───────────────────────┐
                                │   Data Collector      │ (Python + Scheduled
                                │   Container (App)     │  Cron Jobs)
                                └───────────┬───────────┘
                                            │
                                            │ (Saves raw data)
                                            ▼
                                ┌───────────────────────┐
                                │  Database Container   │
                                │     (PostgreSQL)      │
                                └───────────┬───────────┘
                                            │ (Returns historical data)
                                            ▼
                                ┌───────────────────────┐
                                │   REST API Container  │ (On-demand processing
                                │       (FastAPI)       │  via Pandas)
                                └───────────┬___________┘
                                            │
                                            │ (HTTP GET Request / JSON Response)
                                            ▼
                                ┌───────────────────────┐
                                │  Frontend Container   │ (Presentation Layer)
                                │     (React + Vite)    │
                                └───────────────────────┘
```

#### General Workflow:

1. A scheduled background worker triggers periodic data ingestion from product prices (**Canopy API**) and wage indexes (**ILOSTAT API**).
2. Raw data is recorded and historically persisted inside **PostgreSQL**.
3. When a user interacts with the frontend and selects a country or product, the backend (**FastAPI**) queries the database and processes comparative metrics **on-demand**.
4. The frontend renders the processed results seamlessly.

### 🧰 Tech Stack

| Layer | Technologies |
| --- | --- |
| **Backend** | Python, FastAPI, Pandas, SQLAlchemy |
| **Database** | PostgreSQL |
| **Frontend** | React, Vite, Tailwind CSS |
| **Infrastructure** | Docker, Docker Compose |

### 📂 Repository Structure

```
.
├── microservico_coletor/   # Python source code (Extractor, DB Connector, and Jobs)
├── db_init/                # SQL/Shell scripts for database initialization & permissions
├── docker-compose.yml      # Container orchestration (Database + Ingestion Application)
└── README.md
```

#### Main Database Tables:

`categories`, `countries`, `country_stats`, `country_translations`, `exchange_rates`, `price_history`, `product_asins`, `products`, `salary_history`, `salary_indicators`, `sources`, `staging_salary`.

### ⚙️ Prerequisites

- Docker and Docker Compose installed
- Git

### 🚀 Getting Started

#### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repository.git
cd your-repository
```

#### 2. Configure Environment Variables

```bash
cp .env.example .env
# Open and edit .env with your database credentials and external API keys
```

#### 3. Spin Up the Containers

```bash
docker compose up -d --build
```

#### 4. Monitor Ingestion Logs

```bash
docker logs coletor_dados_app
```

#### 5. Access the Application

- **Frontend:** `http://localhost:<port>`
- **Interactive API Docs (Swagger/OpenAPI):** `http://localhost:8000/docs`

### 📡 API Usage Example

**Request:**

```bash
curl -X GET "http://localhost:8000/analise/pais/1" -H "accept: application/json"
```

**Response:**

```json
[
  {
    "sku": "COCA_ZERO_12P",
    "product_name": "COCA_ZERO_12P",
    "country_id": 1,
    "price": 47.68,
    "hours_needed_avg": 2.14,
    "hours_needed_min": 5,
    "collection_date": "2026-02-10T18:06:33Z"
  }
]
```

### 📊 MVP Scope

To validate the architecture, the Minimum Viable Product (MVP) has been scoped to:

- **Countries:** 🇧🇷 Brazil · 🇪🇸 Spain · 🇺🇸 USA · 🇮🇳 India · 🇯🇵 Japan
- **Products:** LEGO Classic 10698 · Coca-Cola · Havaianas Top · AirPods Pro 3
- **Target Wage Indicators:**
  - `EAR_4MTH_SEX_CUR_NB_A`: Mean nominal monthly earnings of employees.
  - `MWG_2MTH_SEX_CUR_NB_A`: Statutory minimum wage.
  - `QLS_HW_AVE_NB_A`: Average hours actually worked per week.

### 🧠 Methodology

Applied research using a blended qualitative and quantitative approach combining:

- **API Data Sourcing:** ILOSTAT (wages) and Canopy API (product retail pricing).
- **Software Engineering Practices:** Modular architecture, REST API design, Docker environments, and PostgreSQL relational consistency.
- **MVP Strategy:** Restricted scope tailored to address public API consumption limits while verifying architectural viability.

### ✅ Conclusion

- Automated integration achieved between third-party data APIs and the relational database layer.
- Centralized computation of comparative metrics managed efficiently by the backend.
- Data persistence ensures structural foundation for historical trend analytics.
- High maintainability and scalability facilitated through modular separation of concerns.
- Technical viability validated under the MVP scope, leaving the architectural foundation fully optimized for incremental evolution.

---

## 🇧🇷 Português

Coleta automaticamente preços de produtos e indicadores salariais via APIs públicas, calculando métricas como percentual de comprometimento de renda e horas de trabalho necessárias para adquirir um mesmo produto em diferentes países.

### 📌 Problema

- O valor nominal do dinheiro não reflete necessariamente a capacidade de consumo real local.
- Dados econômicos (preços e salários) permanecem distribuídos em fontes diferentes, com formatos heterogêneos.
- Falta uma ferramenta que integre e processe esses dados de forma automatizada e comparável.

### 🎯 Objetivo do Projeto

Desenvolver um sistema web capaz de:

- ✅ Coletar preços automaticamente
- ✅ Integrar indicadores salariais e trabalhistas
- ✅ Persistir dados historicamente
- ✅ Processar métricas comparativas sob demanda
- ✅ Disponibilizar os resultados via API REST e interface Frontend

### 🏗️ Arquitetura do Sistema

Arquitetura modular inspirada em microsserviços, com componentes isolados em contêineres Docker e comunicação padronizada via API REST.

```
                ┌────────────────────────┐      ┌────────────────────────┐
                │       Canopy API       │      │      ILOSTAT API       │
                │  (Preços de Produtos)  │      │ (Indicadores Salariais)│
                └───────────┬────────────┘      └───────────┬────────────┘
                            │ (JSON)                        │ (JSON)
                            └───────────────┬───────────────┘
                                            ▼
                                ┌───────────────────────┐
                                │   Container Coletor   │ (Python + Jobs
                                │   de Dados (App)      │  Agendados)
                                └───────────┬───────────┘
                                            │
                                            │ (Grava dados brutos)
                                            ▼
                                ┌───────────────────────┐
                                │   Container Banco de  │
                                │   Dados (PostgreSQL)  │
                                └───────────┬───────────┘
                                            │ (Retorna dados históricos)
                                            ▼
                                ┌───────────────────────┐
                                │  Container API REST   │ (Processamento sob
                                │       (FastAPI)       │  demanda via Pandas)
                                └───────────┬___________┘
                                            │
                                            │ (Requisição HTTP GET / Resposta JSON)
                                            ▼
                                ┌───────────────────────┐
                                │  Container Frontend   │ (Camada de
                                │     (React + Vite)    │  Apresentação)
                                └───────────────────────┘
```

#### Fluxo Geral:

1. Um processo agendado dispara a coleta periódica de preços (**Canopy API**) e salários (**ILOSTAT API**).
2. Os dados brutos são gravados e persistidos historicamente no **PostgreSQL**.
3. O usuário acessa o frontend e seleciona um país ou produto; o backend (**FastAPI**) consulta o banco e processa as métricas **sob demanda**.
4. O frontend exibe os resultados processados de forma limpa.

### 🧰 Tecnologias Utilizadas

| Camada | Tecnologias |
| --- | --- |
| **Backend** | Python, FastAPI, Pandas, SQLAlchemy |
| **Banco de dados** | PostgreSQL |
| **Frontend** | React, Vite, Tailwind CSS |
| **Infraestrutura** | Docker, Docker Compose |

### 📂 Estrutura do Repositório

```
.
├── microservico_coletor/   # Código-fonte em Python (Extrator, Conector DB e Jobs)
├── db_init/                # Scripts SQL/Shell para inicialização do banco e permissões
├── docker-compose.yml      # Orquestração dos containers (Banco de Dados + Aplicação)
└── README.md
```

#### Principais Tabelas do Banco de Dados:

`categories`, `countries`, `country_stats`, `country_translations`, `exchange_rates`, `price_history`, `product_asins`, `products`, `salary_history`, `salary_indicators`, `sources`, `staging_salary`.

### ⚙️ Pré-requisitos

- Docker e Docker Compose instalados
- Git

### 🚀 Como Rodar o Projeto

#### 1. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

#### 2. Configurar Variáveis de Ambiente

```bash
cp .env.example .env
# Edite o .env com suas credenciais de banco de dados e chaves de API
```

#### 3. Subir os Containers

```bash
docker compose up -d --build
```

#### 4. Verificar os Logs da Coleta de Dados

```bash
docker logs coletor_dados_app
```

#### 5. Acessar a Aplicação

- **Frontend:** `http://localhost:<porta>`
- **API (Docs Interativas via Swagger):** `http://localhost:8000/docs`

### 📡 Exemplo de Uso da API

**Requisição:**

```bash
curl -X GET "http://localhost:8000/analise/pais/1" -H "accept: application/json"
```

**Resposta:**

```json
[
  {
    "sku": "COCA_ZERO_12P",
    "product_name": "COCA_ZERO_12P",
    "country_id": 1,
    "price": 47.68,
    "hours_needed_avg": 2.14,
    "hours_needed_min": 5,
    "collection_date": "2026-02-10T18:06:33Z"
  }
]
```

### 📊 Escopo do MVP

Para validar a arquitetura, o produto mínimo viável (MVP) foi restrito a:

- **Países:** 🇧🇷 Brasil · 🇪🇸 Espanha · 🇺🇸 EUA · 🇮🇳 Índia · 🇯🇵 Japão
- **Produtos:** LEGO Classic 10698 · Coca-Cola · Havaianas Top · AirPods Pro 3
- **Indicadores Salariais Alvo:**
  - `EAR_4MTH_SEX_CUR_NB_A`: Rendimento nominal médio mensal dos empregados.
  - `MWG_2MTH_SEX_CUR_NB_A`: Salário-mínimo legal estatutário.
  - `QLS_HW_AVE_NB_A`: Média de horas efetivamente trabalhadas por semana.

### 🧠 Metodologia

Pesquisa aplicada de abordagem qualitativa e quantitativa, combinando:

- **Dados de APIs:** ILOSTAT (salários) e Canopy API (preços de produtos).
- **Engenharia de Software:** Arquitetura modular, API REST, Docker e consistência relacional com PostgreSQL.
- **MVP:** Escopo reduzido para contornar limites das APIs públicas, validando de forma assertiva a viabilidade técnica e arquitetural.

### ✅ Conclusão

- Integração automatizada alcançada entre as APIs de terceiros e a camada de persistência relacional.
- Processamento centralizado e eficiente das métricas comparativas gerenciado diretamente pelo backend.
- Preservação da série histórica de dados garantindo a base estrutural para futuras análises de tendência.
- Alta manutenibilidade e escalabilidade proporcionadas pela separação modular de responsabilidades.
- Viabilidade técnica totalmente validada no escopo do MVP, mantendo a fundação arquitetural pronta para evolução incremental.

---

## 📚 Academic References / Referências Bibliográficas

- **ASHENFELTER, O.** *Cross-country Comparisons of Wage Rates: The Big Mac Index*. Princeton University, 2001.
- **CASSEL, G.** *Money and Foreign Exchange After 1914*. Constable & Co., 1922.
- **STIGLITZ, J.E.; FITOUSSI, J.-P.; DURAND, M.** *Beyond GDP: Measuring What Counts for Economic and Social Performance*. OECD Publishing, 2018.
- **SOMMERVILLE, I.** *Software Engineering / Engenharia de Software*. 10th ed. Pearson, 2016.
- **International Labour Organization (ILO).** *ILOSTAT — Database of Labour Statistics*. Available at: https://ilostat.ilo.org/
- **Canopy API.** *Canopy API Documentation*. Available at: https://www.canopyapi.co/
- **World Bank.** *International Comparison Program (ICP) — Methodology*. Available at: https://www.worldbank.org/en/programs/icp

---

## 📄 License / Licença

This project is purely academic, developed as a Capstone Project (TCC) for the USP/ESALQ MBA program. Refer to the `LICENSE` file for further compliance details (if applicable).
