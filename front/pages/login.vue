<template>
  <bef-login-form-card>
    <template #form-card-content>
      <toast-notification />
      <v-form v-model="isValid">
        <user-form-email v-model="params.auth.email" no-validation />
        <user-form-password
          v-model="params.auth.password"
          no-validation
        />
        <v-card-actions>
          <nuxt-link to="#" class="body-2 text-decoration-none">
            パスワードを忘れた?
          </nuxt-link>
        </v-card-actions>
        <v-card-text class="px-0">
          <v-btn
            :disabled="!isValid || loading"
            :loading="loading"
            block
            color="myblue"
            class="text-white"
            @click="login"
          >
            ログインする
          </v-btn>
          <v-btn
            block
            :loading="loading"
            color="success"
            class="mt-4"
            @click="guestLogin"
          >
            ゲストログイン
          </v-btn>
        </v-card-text>
      </v-form>
    </template>
  </bef-login-form-card>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '~/composables/useAuth'
import { useToastStore } from '~/stores/toast'

definePageMeta({
  layout: 'beforeLogin'
})

const { login: authLogin } = useAuth()
const toastStore = useToastStore()
const router = useRouter()

const isValid = ref(false)
const loading = ref(false)
const params = reactive({
  auth: { email: "", password: "" }
})
const guestParams = {
  auth: { email: "user0@example.com", password: "password" }
}

// ログイン処理
async function login() {
  loading.value = true
  if (isValid.value) {
    try {
      const config = useRuntimeConfig()
      const response = await $fetch('/api/v1/user_token', {
        method: 'POST',
        body: params,
        baseURL: config.public.apiBaseUrl
      })
      await authSuccessful(response)
    } catch (error: any) {
      authFailure(error)
    }
  }
  loading.value = false
}

// ゲストログイン処理
async function guestLogin() {
  loading.value = true
  try {
    const config = useRuntimeConfig()
    const response = await $fetch('/api/v1/user_token', {
      method: 'POST',
      body: guestParams,
      baseURL: config.public.apiBaseUrl
    })
    await authSuccessful(response)
  } catch (error: any) {
    authFailure(error)
  }
  loading.value = false
}

// ログイン成功処理
async function authSuccessful(response: any) {
  await authLogin(response)
  
  // 保存されたルートパスを取得
  const savedRoute = localStorage.getItem('rememberRoute')
  const redirectTo = savedRoute ? JSON.parse(savedRoute) : '/'
  
  router.push(redirectTo)
}

// ログイン失敗処理
function authFailure(error: any) {
  if (error.response?.status === 404) {
    toastStore.showToast({ 
      message: "ユーザーが見つかりません😷", 
      color: "error" 
    })
  } else {
    toastStore.showToast({ 
      message: "ログインに失敗しました", 
      color: "error" 
    })
  }
}
</script>