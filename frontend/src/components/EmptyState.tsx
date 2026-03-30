import { Link } from "react-router";

interface EmptyStateProps {
  title: string;
  description: string;
}

function EmptyState({ title, description }: EmptyStateProps) {
  return (
    <div className="surface flex min-h-72 flex-col items-center justify-center px-8 py-14 text-center">
      <div className="text-5xl">📭</div>
      <h2 className="mt-5 text-2xl font-semibold text-white">{title}</h2>
      <p className="mt-3 max-w-2xl text-slate-400">{description}</p>
      <Link
        to="/"
        className="mt-8 rounded-full bg-brand-500 px-5 py-3 text-sm font-medium text-white hover:bg-brand-400"
      >
        Voltar ao início
      </Link>
    </div>
  );
}

export default EmptyState;
