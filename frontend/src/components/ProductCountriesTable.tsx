import { COUNTRIES } from "../data/catalog";
import { useSortableData } from "../hooks/useSortableData";
import type { AnalysisRow } from "../types/api";
import { formatCurrency, formatHours, formatPercent } from "../utils/format";
import SortButton from "./SortButton";

interface ProductCountriesTableProps {
  rows: AnalysisRow[];
}

function ProductCountriesTable({ rows }: ProductCountriesTableProps) {
  const { sortedItems, sortConfig, requestSort } = useSortableData(rows, {
    key: "hours_needed_avg_salary",
    direction: "asc"
  });

  return (
    <div className="surface overflow-hidden">
      <div className="overflow-x-auto">
        <table className="data-table min-w-full">
          <thead className="bg-white/5">
            <tr>
              <th>País</th>
              <th>
                <SortButton
                  label="Preço local"
                  active={sortConfig.key === "price"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("price")}
                />
              </th>
              <th>
                <SortButton
                  label="Salário médio"
                  active={sortConfig.key === "avg_salary_month"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("avg_salary_month")}
                />
              </th>
              <th>
                <SortButton
                  label="Salário mínimo"
                  active={sortConfig.key === "min_salary_month"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("min_salary_month")}
                />
              </th>
              <th>
                <SortButton
                  label="% salário médio"
                  active={sortConfig.key === "price_pct_avg_salary"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("price_pct_avg_salary")}
                />
              </th>
              <th>
                <SortButton
                  label="% salário mínimo"
                  active={sortConfig.key === "price_pct_min_salary"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("price_pct_min_salary")}
                />
              </th>
              <th>
                <SortButton
                  label="Horas / salário médio"
                  active={sortConfig.key === "hours_needed_avg_salary"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("hours_needed_avg_salary")}
                />
              </th>
              <th>
                <SortButton
                  label="Horas / salário mínimo"
                  active={sortConfig.key === "hours_needed_min_salary"}
                  direction={sortConfig.direction}
                  onClick={() => requestSort("hours_needed_min_salary")}
                />
              </th>
            </tr>
          </thead>
          <tbody>
            {sortedItems.map((row) => {
              const country = COUNTRIES[row.iso3];

              return (
                <tr key={`${row.iso3}-${row.sku}`}>
                  <td>
                    <div className="flex min-w-52 items-center gap-3">
                      <div className="text-2xl">{country.flag}</div>
                      <div>
                        <div className="font-medium text-white">{country.name}</div>
                        <div className="mt-1 text-xs text-slate-400">{row.iso3}</div>
                      </div>
                    </div>
                  </td>
                  <td>{formatCurrency(row.price, country.currency)}</td>
                  <td>{formatCurrency(row.avg_salary_month, country.currency)}</td>
                  <td>{formatCurrency(row.min_salary_month, country.currency)}</td>
                  <td>{formatPercent(row.price_pct_avg_salary)}</td>
                  <td>{formatPercent(row.price_pct_min_salary)}</td>
                  <td>{formatHours(row.hours_needed_avg_salary)}</td>
                  <td>{formatHours(row.hours_needed_min_salary)}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default ProductCountriesTable;
