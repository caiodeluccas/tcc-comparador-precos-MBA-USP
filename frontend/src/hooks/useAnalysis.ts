import { useEffect, useState } from "react";
import { fetchCountryAnalysis, fetchProductAnalysis } from "../services/api";
import type { AnalysisResponse, CountryCode, ProductSku } from "../types/api";

interface AsyncState {
  data: AnalysisResponse;
  loading: boolean;
  error: string | null;
}

const INITIAL_STATE: AsyncState = {
  data: [],
  loading: true,
  error: null
};

export function useCountryAnalysis(iso3?: CountryCode) {
  const [state, setState] = useState<AsyncState>(INITIAL_STATE);

  useEffect(() => {
    if (!iso3) {
      return;
    }

    let active = true;

    async function load() {
      setState(INITIAL_STATE);

      try {
        const data = await fetchCountryAnalysis(iso3);

        if (!active) {
          return;
        }

        setState({
          data,
          loading: false,
          error: null
        });
      } catch (error) {
        if (!active) {
          return;
        }

        setState({
          data: [],
          loading: false,
          error:
            error instanceof Error
              ? error.message
              : "Não foi possível carregar os dados."
        });
      }
    }

    load();

    return () => {
      active = false;
    };
  }, [iso3]);

  return state;
}

export function useProductAnalysis(sku?: ProductSku) {
  const [state, setState] = useState<AsyncState>(INITIAL_STATE);

  useEffect(() => {
    if (!sku) {
      return;
    }

    let active = true;

    async function load() {
      setState(INITIAL_STATE);

      try {
        const data = await fetchProductAnalysis(sku);

        if (!active) {
          return;
        }

        setState({
          data,
          loading: false,
          error: null
        });
      } catch (error) {
        if (!active) {
          return;
        }

        setState({
          data: [],
          loading: false,
          error:
            error instanceof Error
              ? error.message
              : "Não foi possível carregar os dados."
        });
      }
    }

    load();

    return () => {
      active = false;
    };
  }, [sku]);

  return state;
}
