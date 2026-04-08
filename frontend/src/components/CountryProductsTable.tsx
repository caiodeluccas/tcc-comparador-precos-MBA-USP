import { PRODUCTS } from "../data/catalog";
import { useSortableData } from "../hooks/useSortableData";
import type { AnalysisRow } from "../types/api";
import {
  formatCurrency,
  formatHoursToHms,
  formatPercent
} from "../utils/format";
import SortButton from "./SortButton";

interface CountryProductsTableProps {
  rows: AnalysisRow[];
  currency: string;
}

function CountryProductsTable({ rows, currency }: CountryProductsTableProps) {
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
              <th>Produto</th>
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
              const product = PRODUCTS[row.sku];

              return (
                <tr key={`${row.iso3}-${row.sku}`}>
                  <td>
                    <div className="flex min-w-72 items-center gap-4">
                      <img
                        src={product.image}
                        alt={product.name}
                        className="h-16 w-16 rounded-2xl border border-white/10 bg-white object-cover p-1"
                      />
                      <div>
                        <div className="font-medium text-white">{product.name}</div>
                        <div className="mt-1 text-xs text-slate-400">
                          {product.category} · {row.sku}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td>{formatCurrency(row.price, currency)}</td>
                  <td>{formatPercent(row.price_pct_avg_salary)}</td>
                  <td>{formatPercent(row.price_pct_min_salary)}</td>
                  <td>{formatHoursToHms(row.hours_needed_avg_salary)}</td>
                  <td>{formatHoursToHms(row.hours_needed_min_salary)}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default CountryProductsTable;