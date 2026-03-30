import type { ReactNode } from "react";

interface SectionCardProps {
  title?: string;
  description?: string;
  children: ReactNode;
}

function SectionCard({ title, description, children }: SectionCardProps) {
  return (
    <section className="surface p-6">
      {(title || description) && (
        <div className="mb-5">
          {title && <h2 className="text-xl font-semibold text-white">{title}</h2>}
          {description && <p className="mt-2 text-sm text-slate-400">{description}</p>}
        </div>
      )}
      {children}
    </section>
  );
}

export default SectionCard;
