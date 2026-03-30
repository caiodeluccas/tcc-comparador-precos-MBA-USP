import type { AnalysisResponse, CountryCode, ProductSku } from "../types/api";

const API_BASE_URL = "http://localhost:8000";

async function fetchJson(url: string): Promise<AnalysisResponse> {
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(`Falha em ${url}: ${response.status}`);
  }

  const payload = await response.json();

  if (Array.isArray(payload)) {
    return payload as AnalysisResponse;
  }

  if (Array.isArray(payload?.data)) {
    return payload.data as AnalysisResponse;
  }

  throw new Error(`Resposta inesperada em ${url}`);
}

export function fetchCountryAnalysis(iso3: CountryCode) {
  return fetchJson(`${API_BASE_URL}/analise/pais/${iso3}`);
}

export function fetchProductAnalysis(sku: ProductSku) {
  return fetchJson(`${API_BASE_URL}/analise/produto/${sku}`);
}