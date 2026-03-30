import PageIntro from "../components/PageIntro";
import SectionCard from "../components/SectionCard";

function AboutPage() {
  return (
    <div className="space-y-8">
      <PageIntro
        eyebrow="Sobre"
        title="Sobre o projeto"
        description="Este projeto foi desenvolvido como parte de um TCC com o objetivo de comparar a acessibilidade de produtos entre países a partir de esforço real de compra. Em vez de focar apenas em preço nominal, a proposta é observar quanto da renda mensal uma pessoa precisa comprometer e quantas horas de trabalho seriam necessárias para adquirir o mesmo item em diferentes contextos nacionais."
      />

      <section className="grid gap-6 lg:grid-cols-2">
        <SectionCard title="Motivação">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              Comparações tradicionais entre países costumam destacar valores monetários
              isolados ou conversões cambiais. Neste projeto, o interesse principal é
              tornar a leitura mais próxima da realidade cotidiana de consumo.
            </p>
            <p>
              A pergunta central não é apenas quanto um produto custa, mas quanto ele
              pesa dentro da renda local de quem vive naquele país.
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Objetivo do sistema">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              O sistema busca apresentar, de forma simples e comparável, indicadores de
              acessibilidade de consumo para um conjunto definido de produtos e países.
            </p>
            <p>
              Para isso, o frontend consome uma API já processada, priorizando clareza
              visual, organização e baixo acoplamento com a lógica de cálculo.
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Diferencial da análise">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              O diferencial do projeto está em comparar preço local, percentual do
              salário e horas de trabalho necessárias para compra, em vez de reduzir a
              análise a uma conversão para dólar.
            </p>
            <p>
              Essa abordagem permite uma leitura mais coerente com poder de compra e
              acessibilidade relativa entre países.
            </p>
          </div>
        </SectionCard>

        <SectionCard title="Escopo do MVP">
          <div className="space-y-4 text-sm leading-7 text-slate-300">
            <p>
              Esta versão foi planejada como um MVP viável para desenvolvimento
              individual, com foco em simplicidade, baixo custo operacional e
              apresentação clara para fins acadêmicos.
            </p>
            <p>
              O escopo atual considera um conjunto controlado de países, produtos e uma
              única fonte de preços, permitindo validar a proposta sem ampliar
              complexidade desnecessária.
            </p>
          </div>
        </SectionCard>
      </section>

      <SectionCard title="Uso adequado das informações">
        <div className="space-y-4 text-sm leading-7 text-slate-300">
          <p>
            Os resultados apresentados possuem caráter informativo, acadêmico e de
            consulta. Eles não devem ser utilizados de forma isolada para tomada de
            decisão financeira, comercial, jurídica ou estratégica.
          </p>
          <p>
            A interpretação dos dados deve considerar contexto, disponibilidade da
            fonte, recorte do MVP e limitações metodológicas descritas nesta aplicação.
          </p>
        </div>
      </SectionCard>
    </div>
  );
}

export default AboutPage;
