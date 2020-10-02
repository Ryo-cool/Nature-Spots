<template>
  <div>
    オブです
  </div>
</template>

<script>
export default {
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  }
}
</script>