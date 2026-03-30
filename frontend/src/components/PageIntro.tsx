import type { ReactNode } from "react";

interface PageIntroProps {
  eyebrow?: string;
  title: string;
  description: string;
  aside?: ReactNode;
}

function PageIntro({ eyebrow, title, description, aside }: PageIntroProps) {
  return (
    <section className="grid gap-6 lg:grid-cols-[1.3fr_0.9fr] lg:items-end">
      <div>
        {eyebrow && (
          <div className="mb-3 text-xs font-semibold tracking-[0.2em] text-brand-300 uppercase">
            {eyebrow}
          </div>
        )}
        <h1 className="page-title">{title}</h1>
        <p className="mt-4 max-w-3xl text-base leading-7 text-slate-300">
          {description}
        </p>
      </div>
      {aside}
    </section>
  );
}

export default PageIntro;
