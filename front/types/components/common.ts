import type { VNode } from "vue";

// 共通のprops型
export interface BaseProps {
  className?: string;
  style?: string | object;
}

// イベントハンドラの型
export interface EventHandlers {
  onClick?: (event: MouseEvent) => void;
  onInput?: (event: Event) => void;
  onChange?: (event: Event) => void;
  onSubmit?: (event: Event) => void;
  onFocus?: (event: FocusEvent) => void;
  onBlur?: (event: FocusEvent) => void;
}

// スロットの型
export interface DefaultSlotProps {
  default?: () => VNode | VNode[];
}

// 共通のコンポーネントオプション
export interface BaseComponentOptions {
  name: string;
  inheritAttrs?: boolean;
}

// フォーム関連の共通型
export interface FormFieldProps extends BaseProps {
  label?: string;
  name: string;
  value: string | number | boolean | null;
  placeholder?: string;
  required?: boolean;
  disabled?: boolean;
  error?: string;
  helperText?: string;
}

// ボタン関連の共通型
export interface ButtonProps extends BaseProps {
  type?: "button" | "submit" | "reset";
  variant?: "primary" | "secondary" | "outline" | "text";
  size?: "small" | "medium" | "large";
  disabled?: boolean;
  loading?: boolean;
  icon?: string;
  fullWidth?: boolean;
}

// アイコン関連の共通型
export interface IconProps extends BaseProps {
  name: string;
  size?: "small" | "medium" | "large" | number;
  color?: string;
}

// ローディング関連の共通型
export interface LoadingProps extends BaseProps {
  size?: "small" | "medium" | "large";
  color?: string;
  fullScreen?: boolean;
}

// エラー表示関連の共通型
export interface ErrorProps extends BaseProps {
  message: string;
  code?: string | number;
  retry?: () => void;
}

// 画像関連の共通型
export interface ImageProps {
  src: string;
  alt?: string;
  width?: number | string;
  height?: number | string;
  lazy?: boolean;
  sizes?: string;
  quality?: number;
}
