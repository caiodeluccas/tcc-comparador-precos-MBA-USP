function Footer() {
  return (
    <footer className="border-t border-slate-800/80 bg-slate-950/80">
      <div className="px-4 py-4 text-[14px] leading-6 text-slate-400">
        <div className="grid gap-6 md:grid-cols-[1fr_max-content] items-center">
          <p>Frontend MVP para TCC · foco em preço local, salário e horas de trabalho.</p>
          <p className="whitespace-nowrap">
            Os dados exibidos possuem caráter informativo e de consulta. Eles não devem ser utilizados, de forma isolada, para decisões financeiras, comerciais, jurídicas ou estratégicas.
          </p>
        </div>
      </div>
    </footer>
  );
}

export default Footer;