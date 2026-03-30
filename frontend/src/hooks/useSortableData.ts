import { useMemo, useState } from "react";

type Direction = "asc" | "desc";

export interface SortConfig<T> {
  key: keyof T;
  direction: Direction;
}

export function useSortableData<T extends Record<string, unknown>>(
  items: T[],
  initialConfig: SortConfig<T>
) {
  const [sortConfig, setSortConfig] = useState<SortConfig<T>>(initialConfig);

  const sortedItems = useMemo(() => {
    const sortableItems = [...items];

    sortableItems.sort((a, b) => {
      const aValue = a[sortConfig.key];
      const bValue = b[sortConfig.key];

      if (aValue === bValue) {
        return 0;
      }

      if (aValue === undefined || aValue === null) {
        return 1;
      }

      if (bValue === undefined || bValue === null) {
        return -1;
      }

      const result = aValue < bValue ? -1 : 1;
      return sortConfig.direction === "asc" ? result : -result;
    });

    return sortableItems;
  }, [items, sortConfig]);

  function requestSort(key: keyof T) {
    setSortConfig((current) => {
      if (current.key === key) {
        return {
          key,
          direction: current.direction === "asc" ? "desc" : "asc"
        };
      }

      return {
        key,
        direction: "asc"
      };
    });
  }

  return { sortedItems, sortConfig, requestSort };
}
