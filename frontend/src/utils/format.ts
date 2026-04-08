export function formatCurrency(value: number, currency: string) {
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency,
    maximumFractionDigits: currency === "JPY" ? 0 : 2
  }).format(value);
}

export function formatPercent(value: number) {
  return `${new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 2,
    minimumFractionDigits: 0
  }).format(value)}%`;
}

export function formatHours(value: number) {
  return `${new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 2
  }).format(value)} h`;
}

export function formatNumber(value: number) {
  return new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 2
  }).format(value);
}

export function formatHoursToHms(decimalHours: number): string {
  if (!Number.isFinite(decimalHours) || decimalHours < 0) {
    return "-";
  }

  const totalSeconds = Math.round(decimalHours * 3600);

  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  const parts: string[] = [];

  if (hours > 0) parts.push(`${hours} h`);
  if (minutes > 0) parts.push(`${minutes} min`);
  if (seconds > 0 || parts.length === 0) parts.push(`${seconds} s`);

  return parts.join(" ");
}

