export interface ApiResponse<T> {
  data?: T;
  total?: number;
  err?: {
    error: number;
    message: string;
  };
  message?: string;
}
