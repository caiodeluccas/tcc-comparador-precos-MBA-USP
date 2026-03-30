import PageIntro from "../components/PageIntro";
import SectionCard from "../components/SectionCard";

function MethodologyPage() {
  return (
    <div className="space-y-8">
      <PageIntro
        eyebrow="Metodologia"
        title="Como esta comparação é construída"
        description="A proposta do projeto é medir acessibilidade de consumo entre países a partir de esforço real de compra. O foco principal não é converter moedas para dólar, e sim observar o peso relativo do preço dentro da renda local."
      />

      <section className="grid gap-6 lg:grid-cols-2">
        <SectionCard title="Objetivo do projeto">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              O sistema compara o mesmo produto em diferentes países usando preço
              local, salário médio mensal, salário mínimo mensal e métricas derivadas
              de esforço de compra.
            </p>
            <p>
              A principal pergunta respondida pela interface é: quanto do salário uma
              pessoa precisa comprometer e quantas horas precisa trabalhar para comprar
              esse item em cada país?
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Coleta de dados">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              No MVP, a Amazon é a única fonte de preços. A coleta é feita via Canopy
              API, com preocupação explícita em reduzir consumo por causa do limite de
              requisições da ferramenta.
            </p>
            <p>
              Um coletor registra preços por produto e país em uma tabela histórica.
              Em seguida, o processador cruza esses preços com indicadores salariais e
              expõe o resultado por meio da API.
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Limitações assumidas no MVP">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              Nem todo produto aparece em todos os países. Quando a Amazon não
              disponibiliza um preço para a combinação país + produto, o item fica fora
              do resultado.
            </p>
            <p>
              Essa ausência não é preenchida com média, estimativa ou valor inventado.
              A interface respeita exatamente o retorno do backend.
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Leitura correta dos resultados">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              O valor monetário deve ser lido sempre na moeda local. A comparação não
              tenta responder qual país é “mais barato em dólar”.
            </p>
            <p>
              A interpretação principal está nas métricas de percentual do salário e
              horas necessárias para compra. É isso que torna a análise mais próxima do
              poder de compra real.
            </p>
          </div>
        </SectionCard>
      </section>

      <SectionCard
        title="Campos processados pela API"
        description="Exemplo de métricas que o frontend espera receber do backend processado."
      >
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
          {[
            "sku",
            "iso3",
            "price",
            "avg_salary_month",
            "min_salary_month",
            "price_pct_avg_salary",
            "price_pct_min_salary",
            "hours_needed_avg_salary",
            "hours_needed_min_salary"
          ].map((field) => (
            <div
              key={field}
              className="rounded-2xl border border-white/10 bg-slate-900/80 px-4 py-3 text-sm text-slate-300"
            >
              {field}
            </div>
          ))}
        </div>
      </SectionCard>

      <SectionCard title="Observação para evolução futura">
        <div className="space-y-4 text-sm leading-7 text-slate-300">
          <p>
            O frontend já foi organizado para receber extensões futuras, como filtros,
            snapshots históricos, imagens reais dos produtos vindas da API e ajustes
            para telas menores.
          </p>
          <p>
            Para o TCC, a prioridade foi manter uma experiência simples, clara e
            apresentável, com baixo acoplamento entre cliente e backend.
          </p>
        </div>
      </SectionCard>
    </div>
  );
}

export default MethodologyPage;
