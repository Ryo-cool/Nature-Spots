<template>
  <div />
</template>
<script>
export default {
  layout: 'logout',
  async beforeCreate () {
    await this.$auth.logout()
    this.$router.replace('/')
  }
}
</script>