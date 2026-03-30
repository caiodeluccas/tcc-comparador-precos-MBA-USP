import { useMemo } from "react";
import { Link, useParams } from "react-router";
import CountryProductsTable from "../components/CountryProductsTable";
import EmptyState from "../components/EmptyState";
import ErrorState from "../components/ErrorState";
import LoadingState from "../components/LoadingState";
import PageIntro from "../components/PageIntro";
import StatCard from "../components/StatCard";
import { COUNTRIES } from "../data/catalog";
import { useCountryAnalysis } from "../hooks/useAnalysis";
import type { CountryCode } from "../types/api";
import { formatCurrency } from "../utils/format";

function CountryPage() {
  const params = useParams();
  const iso3 = params.iso3 as CountryCode | undefined;
  const country = iso3 ? COUNTRIES[iso3] : undefined;
  const { data, loading, error } = useCountryAnalysis(iso3);

  const summary = useMemo(() => data[0], [data]);

  if (!country) {
    return (
      <EmptyState
        title="País não encontrado"
        description="O identificador informado não existe no catálogo atual do MVP."
      />
    );
  }

  if (loading) {
    return <LoadingState label={`Carregando análise de ${country.name}...`} />;
  }

  if (error) {
    return <ErrorState message={error} />;
  }

  if (!data.length || !summary) {
    return (
      <EmptyState
        title="Sem dados disponíveis"
        description="Este país não possui itens disponíveis no retorno atual da API. No MVP, ausências não são preenchidas artificialmente."
      />
    );
  }

  return (
    <div className="space-y-8">
      <PageIntro
        eyebrow="Análise por país"
        title={`${country.flag} ${country.name}`}
        description="Nesta visualização, os produtos disponíveis para o país selecionado são comparados com base no preço local, percentual do salário mensal e horas de trabalho necessárias."
        aside={
          <div className="surface p-6">
            <div className="text-xs font-semibold tracking-[0.16em] text-slate-400 uppercase">
              Catálogo retornado
            </div>
            <div className="mt-4 text-4xl font-semibold text-white">{data.length}</div>
            <div className="mt-2 text-sm text-slate-400">
              produtos disponíveis neste país
            </div>
          </div>
        }
      />

      <div className="grid gap-4 md:grid-cols-3">
        <StatCard
          label="Salário médio mensal"
          value={formatCurrency(summary.avg_salary_month, country.currency)}
          hint="Valor recebido do backend processado."
        />
        <StatCard
          label="Salário mínimo mensal"
          value={formatCurrency(summary.min_salary_month, country.currency)}
          hint="Usado como referência de esforço mínimo."
        />
        <StatCard
          label="Moeda local"
          value={country.currency}
          hint="A interface não converte os preços para dólar."
        />
      </div>

      <CountryProductsTable rows={data} currency={country.currency} />

      <div className="flex items-center justify-between rounded-2xl border border-white/10 bg-white/4 px-5 py-4">
        <div className="text-sm text-slate-300">
          Produtos ausentes não aparecem na tabela, de forma intencional no MVP.
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

export default CountryPage;
