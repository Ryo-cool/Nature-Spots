// 共通のレスポンス型
export interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface PaginationMeta {
  currentPage: number;
  totalPages: number;
  totalCount: number;
  perPage: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: PaginationMeta;
}

// 共通のエラーレスポンス型
export interface ApiError {
  message: string;
  errors?: {
    [key: string]: string[];
  };
  statusCode?: number;
}

// 共通のリクエストパラメータ
export interface PaginationParams {
  page?: number;
  perPage?: number;
}

export interface SortParams {
  sortBy?: string;
  order?: "asc" | "desc";
}

export interface SearchParams {
  query?: string;
  filters?: {
    [key: string]: string | number | boolean | (string | number)[];
  };
}
