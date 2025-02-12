import { ActionTree, MutationTree, GetterTree } from "vuex"

// ルートステートの型定義
export interface RootState {
  version: string
}

// 認証関連の型定義
export interface User {
  id: number
  email: string
  name: string
}

export interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
}

export interface AuthGetters extends GetterTree<AuthState, RootState> {
  isAuthenticated: (state: AuthState) => boolean
  user: (state: AuthState) => User | null
}

export interface AuthMutations extends MutationTree<AuthState> {
  SET_USER: (state: AuthState, user: User | null) => void
  SET_TOKEN: (state: AuthState, token: string | null) => void
  SET_AUTH: (state: AuthState, isAuth: boolean) => void
}

export interface AuthActions extends ActionTree<AuthState, RootState> {
  login: (
    context: any,
    credentials: { email: string; password: string }
  ) => Promise<void>
  logout: (context: any) => Promise<void>
  fetchUser: (context: any) => Promise<void>
}

// スポット関連の型定義
export interface Spot {
  id: number
  name: string
  description: string
  location: string
  images: string[]
  createdAt: string
  updatedAt: string
}

export interface SpotState {
  spots: Spot[]
  currentSpot: Spot | null
  loading: boolean
  error: string | null
}

export interface SpotGetters extends GetterTree<SpotState, RootState> {
  allSpots: (state: SpotState) => Spot[]
  currentSpot: (state: SpotState) => Spot | null
  isLoading: (state: SpotState) => boolean
  error: (state: SpotState) => string | null
}

export interface SpotMutations extends MutationTree<SpotState> {
  SET_SPOTS: (state: SpotState, spots: Spot[]) => void
  SET_CURRENT_SPOT: (state: SpotState, spot: Spot | null) => void
  SET_LOADING: (state: SpotState, loading: boolean) => void
  SET_ERROR: (state: SpotState, error: string | null) => void
}

export interface SpotActions extends ActionTree<SpotState, RootState> {
  fetchSpots: (context: any) => Promise<void>
  fetchSpot: (context: any, id: number) => Promise<void>
  createSpot: (context: any, spot: Partial<Spot>) => Promise<void>
  updateSpot: (
    context: any,
    { id, spot }: { id: number; spot: Partial<Spot> }
  ) => Promise<void>
  deleteSpot: (context: any, id: number) => Promise<void>
}
