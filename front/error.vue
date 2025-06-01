<template>
  <v-app>
    <v-container
      class="d-flex flex-column align-center justify-center"
      style="height: 100vh"
    >
      <h1 v-if="error?.statusCode === 404" class="text-h3 mb-6">
        404 ページが見つかりません
      </h1>
      <h1 v-else class="text-h3 mb-6">エラーが発生しました</h1>
      <p class="mb-6">
        {{
          error?.message ||
          "エラーが発生しました。しばらく経ってからもう一度お試しください。"
        }}
      </p>
      <div class="d-flex">
        <v-btn color="primary" class="mr-4" @click="handleError">
          もう一度試す
        </v-btn>
        <v-btn to="/"> ホームに戻る </v-btn>
      </div>
    </v-container>
  </v-app>
</template>

<script setup lang="ts">
interface ErrorObject {
  statusCode?: number;
  message?: string;
}

// Nuxt 3のエラーハンドリング
const error = useError() as ErrorObject;

// エラーをクリアして再読み込み
function handleError() {
  navigateTo("/");
}
</script>
