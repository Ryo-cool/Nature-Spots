// リクエスト型
export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest extends LoginRequest {
  name: string;
}

// レスポンス型
export interface AuthResponse {
  token: string;
  user: {
    id: number;
    email: string;
    name: string;
    createdAt: string;
    updatedAt: string;
  };
}

export interface ErrorResponse {
  message: string;
  errors?: {
    [key: string]: string[];
  };
}
