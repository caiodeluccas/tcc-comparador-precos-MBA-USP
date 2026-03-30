interface ErrorStateProps {
  message: string;
}

function ErrorState({ message }: ErrorStateProps) {
  return (
    <div className="surface border border-rose-500/30 p-6">
      <h2 className="text-xl font-semibold text-white">Falha ao carregar a análise</h2>
      <p className="mt-3 text-slate-300">{message}</p>
      <p className="mt-2 text-sm text-slate-400">
        Verifique a URL base da API, o proxy do Vite e os endpoints definidos em
        <code className="ml-1 rounded bg-white/5 px-2 py-1 text-slate-200">
          src/services/api.ts
        </code>
        .
      </p>
    </div>
  );
}

export default ErrorState;
