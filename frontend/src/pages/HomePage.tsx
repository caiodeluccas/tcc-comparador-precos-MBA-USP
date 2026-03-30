import { Link } from "react-router";
import PageIntro from "../components/PageIntro";
import SectionCard from "../components/SectionCard";
import { COUNTRY_LIST, PRODUCT_LIST } from "../data/catalog";

function HomePage() {
  const visibleProducts = PRODUCT_LIST.filter(
    (product) => product.sku !== "COCA_ZERO_24P"
  );

  return (
    <div className="space-y-8">
      <PageIntro
        eyebrow="MVP · comparador internacional"
        title="Compare o esforço de compra de produtos entre países"
        description="Este frontend foi desenhado para apresentar a comparação principal do projeto: quanto do salário mensal uma pessoa precisa usar e quantas horas precisa trabalhar para comprar um mesmo produto em diferentes países. A moeda permanece local e dados ausentes não são inventados."
        aside={
          <div className="surface flex flex-col gap-3 p-6">
            <div className="text-sm text-slate-300">Fluxo do MVP</div>
            <div className="rounded-2xl border border-white/10 bg-slate-900/80 p-4 text-sm text-slate-300">
              Amazon via Canopy API → price_history → processamento salarial →
              API → frontend
            </div>
            <div className="w-full">
              <Link
                to="/methodology"
                className="block w-full rounded-full bg-white/8 px-4 py-3 text-center text-sm text-white hover:bg-white/12"
              >
                Ver metodologia
              </Link>
            </div>
          </div>
        }
      />

      <section className="grid gap-8 xl:grid-cols-2">
        <SectionCard
          title="Explorar por país"
          description="Selecione um país para ver todos os produtos disponíveis e ordenar pelos indicadores de acessibilidade."
        >
          <div className="grid gap-4 md:grid-cols-2">
            {COUNTRY_LIST.map((country) => (
              <Link
                key={country.iso3}
                to={`/country/${country.iso3}`}
                className="surface-soft group p-5 transition hover:-translate-y-0.5 hover:border-brand-400/40 hover:bg-brand-500/8"
              >
                <div className="flex items-center justify-between">
                  <div className="text-3xl">{country.flag}</div>
                  <div className="rounded-full bg-white/6 px-3 py-1 text-xs text-slate-300">
                    {country.iso3}
                  </div>
                </div>
                <div className="mt-5 text-lg font-semibold text-white">
                  {country.name}
                </div>
                <div className="mt-2 text-sm text-slate-400">
                  Moeda local: {country.currency}
                </div>
              </Link>
            ))}
          </div>
        </SectionCard>

        <SectionCard
          title="Explorar por produto"
          description="Selecione um produto para comparar a acessibilidade dele entre os países onde há preço disponível."
        >
          <div className="grid gap-4">
            {visibleProducts.map((product) => {
              const isCocaCola = product.sku === "COCA_ZERO_12P";

              const displayName = isCocaCola ? "Coca-Cola" : product.name;
              const displayImage = isCocaCola
                ? "/products/coca-zero-unit.png"
                : product.image;

              return (
                <Link
                  key={product.sku}
                  to={`/product/${product.sku}`}
                  className="surface-soft group flex items-center gap-4 p-4 transition hover:-translate-y-0.5 hover:border-brand-400/40 hover:bg-brand-500/8"
                >
                  <img
                    src={displayImage}
                    alt={displayName}
                    className="h-16 w-16 rounded-2xl border border-white/10 bg-white object-cover p-1"
                  />
                  <div className="min-w-0">
                    <div className="truncate text-base font-semibold text-white">
                      {displayName}
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        </SectionCard>
      </section>

      <section className="grid gap-6">
        <div className="surface p-6">
          <div className="text-sm font-semibold text-brand-300">
            Sem conversão cambial
          </div>
          <p className="mt-3 text-sm leading-7 text-slate-300">
            A leitura principal do sistema não é “qual país é mais barato em
            dólar”, mas sim qual exige mais ou menos esforço de compra em
            relação à renda local.
          </p>
        </div>
      </section>
    </div>
  );
}

export default HomePage;