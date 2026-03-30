export type CountryCode = "USA" | "BRA" | "ESP" | "JPN" | "IND";

export type ProductSku =
  | "COCA_ZERO_12P"
  | "COCA_ZERO_24P"
  | "HAVAIANAS_TOP"
  | "LEGO_CLASSIC_10698"
  | "AIRPODS_PRO_3";

export interface AnalysisRow {
  sku: ProductSku;
  iso3: CountryCode;
  price: number;
  avg_salary_month: number;
  min_salary_month: number;
  price_pct_avg_salary: number;
  price_pct_min_salary: number;
  hours_needed_avg_salary: number;
  hours_needed_min_salary: number;
}

export type AnalysisResponse = AnalysisRow[];
