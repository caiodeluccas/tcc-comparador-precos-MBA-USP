import type { ReactNode } from "react";

interface SortButtonProps {
  label: ReactNode;
  active: boolean;
  direction: "asc" | "desc";
  onClick: () => void;
}

function SortButton({ label, active, direction, onClick }: SortButtonProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="inline-flex items-center gap-2 text-left text-xs font-semibold tracking-[0.14em] text-slate-300 uppercase transition hover:text-white"
    >
      <span>{label}</span>
      <span className={active ? "text-brand-300" : "text-slate-500"}>
        {active ? (direction === "asc" ? "↑" : "↓") : "↕"}
      </span>
    </button>
  );
}

export default SortButton;
