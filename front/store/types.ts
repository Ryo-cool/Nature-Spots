import { Store } from 'vuex'

// ルートステートの型定義
export interface RootState {
  version: string
  // 他のルートステートの型をここに追加
}

// モジュールの型定義
export interface AuthState {
  user: {
    id: number | null
    email: string | null
    name: string | null
  } | null
  token: string | null
  isAuthenticated: boolean
}

export interface SpotState {
  spots: Array<{
    id: number
    name: string
    description: string
    location: string
    images: string[]
    // 他のスポット関連のプロパティ
  }>
  currentSpot: {
    id: number
    name: string
    description: string
    location: string
    images: string[]
  } | null
  loading: boolean
  error: string | null
}

// ストア型の拡張
declare module 'vuex' {
  export interface Store<S> {
    $auth: AuthState
    $spot: SpotState
  }
} 