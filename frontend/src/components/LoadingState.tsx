function LoadingState({ label = "Carregando dados..." }: { label?: string }) {
  return (
    <div className="surface flex min-h-56 items-center justify-center p-10">
      <div className="flex items-center gap-3 text-slate-300">
        <div className="h-4 w-4 animate-spin rounded-full border-2 border-slate-500 border-t-brand-400" />
        <span>{label}</span>
      </div>
    </div>
  );
}

export default LoadingState;
