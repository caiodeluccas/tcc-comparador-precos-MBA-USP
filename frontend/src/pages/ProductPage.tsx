import { Link, useParams } from "react-router";
import EmptyState from "../components/EmptyState";
import ErrorState from "../components/ErrorState";
import LoadingState from "../components/LoadingState";
import PageIntro from "../components/PageIntro";
import ProductCountriesTable from "../components/ProductCountriesTable";
import StatCard from "../components/StatCard";
import { COUNTRIES, PRODUCTS } from "../data/catalog";
import { useProductAnalysis } from "../hooks/useAnalysis";
import type { ProductSku } from "../types/api";

function ProductPage() {
  const params = useParams();
  const sku = params.sku as ProductSku | undefined;
  const product = sku ? PRODUCTS[sku] : undefined;
  const { data, loading, error } = useProductAnalysis(sku);

  if (!product) {
    return (
      <EmptyState
        title="Produto não encontrado"
        description="O SKU informado não existe no catálogo atual do frontend."
      />
    );
  }

  const isCocaCola =
    sku === "COCA_ZERO_12P" || sku === "COCA_ZERO_24P";

  const displayName = isCocaCola ? "Coca-Cola Zero" : product.name;
  const displayImage = isCocaCola
    ? "/products/coca-zero-unit.png"
    : product.image;

  if (loading) {
    return <LoadingState label={`Carregando análise do produto ${displayName}...`} />;
  }

  if (error) {
    return <ErrorState message={error} />;
  }

  if (!data.length) {
    return (
      <EmptyState
        title="Sem dados disponíveis"
        description="Este produto não possui países disponíveis no retorno atual. No MVP, isso é tratado como ausência legítima da fonte."
      />
    );
  }

  const countryCount = new Set(data.map((row) => row.iso3)).size;

  return (
    <div className="space-y-8">
      <PageIntro
        eyebrow="Análise por produto"
        title={displayName}
        description={product.description}
        aside={
          <div className="surface flex items-center gap-4 p-5">
            <img
              src={displayImage}
              alt={displayName}
              className="h-24 w-24 rounded-3xl border border-white/10 bg-white object-cover p-2"
            />
            <div>
              <div className="text-xs font-semibold tracking-[0.16em] text-slate-400 uppercase">
                SKU
              </div>
              <div className="mt-2 text-lg font-semibold text-white">{product.sku}</div>
              <div className="mt-1 text-sm text-slate-400">{product.category}</div>
            </div>
          </div>
        }
      />

      <div className="grid gap-4 md:grid-cols-3">
        <StatCard
          label="Países disponíveis"
          value={String(countryCount)}
          hint="Somente países com preço disponível retornam nesta análise."
        />
        <StatCard
          label="Melhor esforço médio"
          value={
            COUNTRIES[
              data.reduce((best, current) =>
                current.hours_needed_avg_salary < best.hours_needed_avg_salary
                  ? current
                  : best
              ).iso3
            ].name
          }
          hint="Menor hours_needed_avg_salary no retorno atual."
        />
        <StatCard
          label="Categoria"
          value={product.category}
          hint="Metadado local do catálogo do frontend."
        />
      </div>

      <ProductCountriesTable rows={data} />

      <div className="flex items-center justify-between rounded-2xl border border-white/10 bg-white/4 px-5 py-4">
        <div className="text-sm text-slate-300">
          Esta comparação cruza preço local, salário mensal e horas de trabalho necessárias.
        </div>
        <Link
          to="/"
          className="rounded-full bg-white/8 px-4 py-2 text-sm text-white hover:bg-white/12"
        >
          Voltar
        </Link>
      </div>
    </div>
  );
}

export default ProductPage;