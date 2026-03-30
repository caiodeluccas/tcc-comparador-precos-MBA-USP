import { NavLink } from "react-router";

const navItemClass = ({ isActive }: { isActive: boolean }) =>
  [
    "rounded-full px-4 py-2 text-sm transition",
    isActive
      ? "bg-brand-500 text-white"
      : "text-slate-300 hover:bg-white/5 hover:text-white"
  ].join(" ");

function Navbar() {
  return (
    <header className="sticky top-0 z-30 border-b border-white/10 bg-slate-950/75 backdrop-blur-xl">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
        <NavLink to="/" className="flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-brand-500/20 text-lg text-brand-300 ring-1 ring-brand-400/30">
            ⏱️
          </div>
          <div>
            <div className="text-sm font-semibold text-white">
              Price Effort Comparator
            </div>
            <div className="text-xs text-slate-400">
              Acessibilidade de produtos entre países
            </div>
          </div>
        </NavLink>

        <nav className="flex items-center gap-2">
          <NavLink to="/" className={navItemClass}>
            Início
          </NavLink>
          <NavLink to="/methodology" className={navItemClass}>
            Metodologia
          </NavLink>
          <NavLink to="/about" className={navItemClass}>
            Sobre
          </NavLink>
        </nav>
      </div>
    </header>
  );
}

export default Navbar;
