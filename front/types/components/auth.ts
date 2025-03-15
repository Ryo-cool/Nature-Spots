import type { LoginRequest, RegisterRequest } from "../api/auth";
import type { BaseProps } from "./common";

// ログインフォーム用のprops
export interface LoginFormProps extends BaseProps {
  onSubmit: (values: LoginRequest) => Promise<void>;
  loading?: boolean;
  error?: string;
}

// 登録フォーム用のprops
export interface RegisterFormProps extends BaseProps {
  onSubmit: (values: RegisterRequest) => Promise<void>;
  loading?: boolean;
  error?: string;
}

// ユーザープロフィール用のprops
export interface UserProfileProps extends BaseProps {
  userId: number;
  editable?: boolean;
  onUpdate?: (values: {
    name: string;
    email: string;
    avatar?: File;
  }) => Promise<void>;
}

// パスワードリセット用のprops
export interface PasswordResetProps extends BaseProps {
  onSubmit: (values: {
    email: string;
    token?: string;
    password?: string;
    passwordConfirmation?: string;
  }) => Promise<void>;
  step: "request" | "reset";
  loading?: boolean;
  error?: string;
}

// ユーザーメニュー用のprops
export interface UserMenuProps extends BaseProps {
  userName: string;
  avatarUrl?: string;
  onLogout: () => void;
  onProfileClick: () => void;
  onSettingsClick: () => void;
}

// 認証ガード用のprops
export interface AuthGuardProps extends BaseProps {
  requireAuth?: boolean;
  redirectTo?: string;
}