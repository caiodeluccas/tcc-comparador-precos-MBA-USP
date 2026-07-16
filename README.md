# 💱 Esforço de Compra — Comparador Internacional de Poder de Compra

**Trabalho de Conclusão de Curso — MBA em Data Science & Analytics (USP/ESALQ)**
Autores: Caio de Luccas Rosolen · Orientador: Mauricio Acconcia Dias

🔗 **Aplicação online:** [esforcodecompra.com.br](https://esforcodecompra.com.br/)


## 📌 Sobre o projeto

Câmbio nominal não é a mesma coisa que poder de compra. Um mesmo produto pode custar "menos dólares" em um país e ainda assim exigir muito mais **horas de trabalho** para ser comprado.

> *"A taxa de câmbio entre duas moedas tende a encontrar o equilíbrio quando o poder de compra interno de ambas as moedas se iguala."* — Gustav Cassel (1922)

Este projeto desenvolve um **sistema web para análise comparativa do poder de compra entre países**, coletando automaticamente preços de produtos e indicadores salariais via APIs públicas, e calculando métricas como **percentual do salário** e **horas de trabalho necessárias** para adquirir um mesmo produto em diferentes países.

### Problema
- O valor nominal do dinheiro não reflete necessariamente a capacidade de consumo.
- Dados econômicos (preços e salários) permanecem distribuídos em fontes diferentes, com formatos heterogêneos.
- Falta uma ferramenta que integre e processe esses dados de forma automatizada e comparável.

### Objetivo
Desenvolver um sistema web capaz de:
- ✅ Coletar preços automaticamente
- ✅ Integrar indicadores salariais
- ✅ Persistir dados historicamente
- ✅ Processar métricas sob demanda
- ✅ Disponibilizar os resultados via API e frontend

---

## 🏗️ Arquitetura do Sistema

Arquitetura modular inspirada em microsserviços, com componentes isolados em contêineres Docker e comunicação padronizada via API REST.

```
┌─────────────────┐       ┌──────────────────┐
│   Canopy API     │       │   ILOSTAT API     │
│  (Preços)        │       │  (Salários)       │
└────────┬─────────┘       └─────────┬─────────┘
         │                           │
         ▼                           ▼
   ┌─────────────────────────────────────────┐
   │        Container Coletor de Dados        │
   │        (coleta periódica automática)      │
   └────────────────────┬──────────────────────┘
                         ▼
              ┌────────────────────┐
              │  PostgreSQL (dados  │
              │  históricos)         │
              └─────────┬───────────┘
                         ▼
              ┌────────────────────┐
              │  FastAPI (API REST) │
              └─────────┬───────────┘
                         ▼
              ┌────────────────────┐
              │ Frontend (React)    │
              └─────────┬───────────┘
                         ▼
                    👤 Usuário
```

**Fluxo geral:**
1. Um processo agendado dispara a coleta periódica de preços (Canopy API) e salários (ILOSTAT API).
2. Os dados brutos são gravados e persistidos historicamente no PostgreSQL.
3. O usuário acessa o frontend, seleciona um país ou produto.
4. O backend (FastAPI) consulta o banco e processa as métricas **sob demanda**.
5. O frontend exibe os resultados processados.

---

## 🧰 Tecnologias utilizadas

| Camada             | Tecnologias                          |
|--------------------|---------------------------------------|
| **Backend**        | Python, FastAPI, Pandas, SQLAlchemy   |
| **Banco de dados** | PostgreSQL                            |
| **Frontend**       | React, Vite, Tailwind CSS             |
| **Infraestrutura** | Docker, Docker Compose                |

---

## 📂 Estrutura do repositório

```
.
├── microservico_coletor/   # Código-fonte em Python (Extrator, Conector DB e Jobs)
├── db_init/                # Scripts SQL/Shell para inicialização do banco e permissões
├── docker-compose.yml      # Orquestração dos containers (Banco de Dados + Aplicação)
└── README.md
```

### Principais tabelas do banco de dados
`categories`, `countries`, `country_stats`, `country_translations`, `exchange_rates`, `price_history`, `product_asins`, `products`, `salary_history`, `salary_indicators`, `sources`, `staging_salary`.

---

## ⚙️ Pré-requisitos

- [Docker](https://docs.docker.com/) e Docker Compose instalados
- [Git](https://git-scm.com/)

---

## 🚀 Como rodar o projeto

1. **Clonar o repositório**
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```

2. **Configurar variáveis de ambiente**
   ```bash
   cp .env.example .env
   # edite o .env com suas credenciais de banco de dados e chaves de API
   ```

3. **Subir os containers**
   ```bash
   docker compose up -d --build
   ```

4. **Verificar os logs da coleta de dados**
   ```bash
   docker logs coletor_dados_app
   ```

5. **Acessar a aplicação**
   - Frontend: `http://localhost:<porta>`
   - API (docs interativas): `http://localhost:8000/docs`

---

## 📡 Exemplo de uso da API

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

---

## 📊 Escopo do MVP

Para validar a arquitetura, o produto mínimo viável (MVP) foi restrito a:

**Países:** 🇧🇷 Brasil · 🇪🇸 Espanha · 🇺🇸 EUA · 🇮🇳 Índia · 🇯🇵 Japão

**Produtos:** LEGO Classic 10698 · Coca-Cola · Havaianas Top · AirPods Pro 3

---

## 🧠 Metodologia

Pesquisa aplicada de abordagem qualitativa e quantitativa, combinando:
- **Dados de APIs:** ILOSTAT (salários) e Canopy API (preços de produtos)
- **Engenharia de software:** arquitetura modular, API REST, Docker, PostgreSQL
- **MVP:** escopo reduzido, respeitando limitações das APIs públicas, com países e produtos selecionados para validação arquitetural

---

## ✅ Conclusão

- Integração automatizada entre APIs externas e banco relacional
- Processamento centralizado de métricas comparativas via backend
- Preservação histórica dos dados para análises futuras
- Arquitetura modular favorecendo manutenção e escalabilidade
- Separação eficiente entre lógica de negócio e apresentação
- Viabilidade técnica da solução validada no escopo do MVP, com base arquitetural preparada para evolução incremental

---

## 📚 Referências

- CASSEL, G. *Money and Foreign Exchange After 1914*. Constable & Co., 1922.
- STIGLITZ, J.E.; FITOUSSI, J.-P.; DURAND, M. *Beyond GDP: Measuring What Counts for Economic and Social Performance*. OECD Publishing, 2018.
- SOMMERVILLE, I. *Engenharia de Software*. 10ª ed. Pearson, 2016.
- International Labour Organization (ILO). *ILOSTAT — Database of Labour Statistics*. Disponível em: https://ilostat.ilo.org/
- Canopy API. *Canopy API Documentation*. Disponível em: https://www.canopyapi.co/
- World Bank. *International Comparison Program (ICP) — Methodology*. Disponível em: https://www.worldbank.org/en/programs/icp

---

## 📄 Licença

Este projeto é de caráter acadêmico, desenvolvido como Trabalho de Conclusão de Curso do MBA USP/ESALQ. Consulte o arquivo `LICENSE` para mais detalhes (se aplicável).
