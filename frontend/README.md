# Frontend MVP · Price Effort Comparator

Frontend desktop-first para o TCC de comparação internacional de acessibilidade de produtos.

## Stack

- React + TypeScript
- Vite
- Tailwind CSS
- React Router

## Rotas

- `/` → tela inicial
- `/country/:iso3` → análise por país
- `/product/:sku` → análise por produto
- `/methodology` → metodologia

## Estrutura

```text
frontend/
├─ public/products/          # imagens locais temporárias
├─ src/
│  ├─ components/            # componentes visuais reutilizáveis
│  ├─ data/                  # catálogo local de países e produtos
│  ├─ hooks/                 # hooks de carregamento e ordenação
│  ├─ layouts/               # layout principal
│  ├─ pages/                 # telas
│  ├─ services/              # acesso à API
│  ├─ types/                 # tipos
│  └─ utils/                 # formatação
├─ Dockerfile
├─ package.json
└─ vite.config.ts
```

## Como rodar

```bash
docker compose up --build frontend
```

Depois abra:

```text
http://localhost:5173
```

## Proxy da API

Durante o desenvolvimento, o Vite faz proxy de `/api` para o container `api_processor`.

Ajuste em `.env` quando necessário:

```env
VITE_API_BASE_URL=/api
VITE_PROXY_TARGET=http://api_processor:8000
```

## Ajuste dos endpoints

Caso os caminhos da sua API sejam diferentes dos candidatos implementados, edite:

```text
src/services/api.ts
```

Atualmente o frontend tenta, nesta ordem:

### País
- `/analysis/countries/:iso3`
- `/analysis/country/:iso3`
- `/country/:iso3`
- `/by-country/:iso3`

### Produto
- `/analysis/products/:sku`
- `/analysis/product/:sku`
- `/product/:sku`
- `/by-product/:sku`

## Observação sobre imagens

As imagens em `public/products/` são placeholders visuais para o MVP.  
Quando o backend passar a expor uma URL de imagem por produto, basta trocar o catálogo local ou adaptar o frontend para usar esse campo.
