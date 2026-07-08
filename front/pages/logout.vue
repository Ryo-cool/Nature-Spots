<template>
  <div />
</template>

<script setup lang="ts">
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuth } from "~/composables/useAuth";

definePageMeta({
  layout: "logout",
});

const { logout } = useAuth();
const router = useRouter();

onMounted(async () => {
  await logout();
  router.replace("/");
});
</script>
