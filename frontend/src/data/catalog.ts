import type { CountryCode, ProductSku } from "../types/api";

export const COUNTRIES: Record<
  CountryCode,
  {
    iso3: CountryCode;
    name: string;
    flag: string;
    currency: string;
    hourlyReference: string;
  }
> = {
  USA: {
    iso3: "USA",
    name: "Estados Unidos",
    flag: "🇺🇸",
    currency: "USD",
    hourlyReference: "salário mensal convertido em esforço por hora"
  },
  BRA: {
    iso3: "BRA",
    name: "Brasil",
    flag: "🇧🇷",
    currency: "BRL",
    hourlyReference: "salário mensal convertido em esforço por hora"
  },
  ESP: {
    iso3: "ESP",
    name: "Espanha",
    flag: "🇪🇸",
    currency: "EUR",
    hourlyReference: "salário mensal convertido em esforço por hora"
  },
  JPN: {
    iso3: "JPN",
    name: "Japão",
    flag: "🇯🇵",
    currency: "JPY",
    hourlyReference: "salário mensal convertido em esforço por hora"
  },
  IND: {
    iso3: "IND",
    name: "Índia",
    flag: "🇮🇳",
    currency: "INR",
    hourlyReference: "salário mensal convertido em esforço por hora"
  }
};

export const PRODUCTS: Record<
  ProductSku,
  {
    sku: ProductSku;
    name: string;
    shortName: string;
    description: string;
    image: string;
    category: string;
  }
> = {
  COCA_ZERO_12P: {
    sku: "COCA_ZERO_12P",
    name: "Coca-Cola Zero 12 pack",
    shortName: "Coca Zero 12P",
    description: "Pacote com 12 unidades de Coca-Cola Zero.",
    image: "/products/coca-12.svg",
    category: "Bebidas"
  },
  COCA_ZERO_24P: {
    sku: "COCA_ZERO_24P",
    name: "Coca-Cola Zero 24 pack",
    shortName: "Coca Zero 24P",
    description: "Pacote com 24 unidades de Coca-Cola Zero.",
    image: "/products/coca-24.svg",
    category: "Bebidas"
  },
  HAVAIANAS_TOP: {
    sku: "HAVAIANAS_TOP",
    name: "Havaianas Top",
    shortName: "Havaianas Top",
    description: "Sandália Havaianas Top.",
    image: "/products/havaianas.svg",
    category: "Vestuário"
  },
  LEGO_CLASSIC_10698: {
    sku: "LEGO_CLASSIC_10698",
    name: "LEGO Classic 10698",
    shortName: "LEGO Classic",
    description: "Caixa LEGO Classic Creative Large com 790 peças.",
    image: "/products/lego.svg",
    category: "Brinquedos"
  },
  AIRPODS_PRO_3: {
    sku: "AIRPODS_PRO_3",
    name: "AirPods Pro 3",
    shortName: "AirPods Pro 3",
    description: "Fone sem fio premium usado como item de referência global.",
    image: "/products/airpods.svg",
    category: "Eletrônicos"
  }
};

export const COUNTRY_LIST = Object.values(COUNTRIES);
export const PRODUCT_LIST = Object.values(PRODUCTS);
