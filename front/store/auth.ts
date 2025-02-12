import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators';
import { AuthState, User } from './types/index';
import { NuxtAxiosInstance } from '@nuxtjs/axios';

interface Context {
  $axios: NuxtAxiosInstance;
}

@Module({
  name: 'auth',
  stateFactory: true,
  namespaced: true,
  dynamic: true
})
export default class Auth extends VuexModule implements AuthState {
  private _user: User | null = null;
  private _token: string | null = null;
  private _isAuthenticated = false;

  get user(): User | null {
    return this._user;
  }

  get token(): string | null {
    return this._token;
  }

  get isAuthenticated(): boolean {
    return this._isAuthenticated;
  }

  @Mutation
  SET_USER(user: User | null): void {
    this._user = user;
  }

  @Mutation
  SET_TOKEN(token: string | null): void {
    this._token = token;
  }

  @Mutation
  SET_AUTH(isAuth: boolean): void {
    this._isAuthenticated = isAuth;
  }

  @Action({ commit: 'SET_TOKEN' })
  async login(credentials: { email: string; password: string }): Promise<string | null> {
    try {
      const response = await (this.context as unknown as Context).$axios.post('/api/v1/user_token', credentials);
      this.context.commit('SET_AUTH', true);
      await this.fetchUser();
      return response.data.token;
    } catch (error) {
      this.context.commit('SET_AUTH', false);
      return null;
    }
  }

  @Action
  async logout(): Promise<void> {
    try {
      await (this.context as unknown as Context).$axios.delete('/api/v1/user_token');
      this.context.commit('SET_TOKEN', null);
      this.context.commit('SET_USER', null);
      this.context.commit('SET_AUTH', false);
    } catch (error) {
      throw error;
    }
  }

  @Action({ commit: 'SET_USER' })
  async fetchUser(): Promise<User | null> {
    try {
      const response = await (this.context as unknown as Context).$axios.get('/api/v1/users/me');
      return response.data;
    } catch (error) {
      return null;
    }
  }
}
