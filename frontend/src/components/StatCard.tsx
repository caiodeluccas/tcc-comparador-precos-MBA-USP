interface StatCardProps {
  label: string;
  value: string;
  hint?: string;
}

function StatCard({ label, value, hint }: StatCardProps) {
  return (
    <div className="surface-soft p-5">
      <div className="text-xs font-semibold tracking-[0.16em] text-slate-400 uppercase">
        {label}
      </div>
      <div className="mt-3 text-2xl font-semibold text-white">{value}</div>
      {hint && <div className="mt-2 text-sm text-slate-400">{hint}</div>}
    </div>
  );
}

export default StatCard;
