class Authentication {
  constructor (ctx) {
    this.store = ctx.store
    this.$axios = ctx.$axios
  }
}

export default ({ store, $axios }, inject) => {
  inject('auth', new Authentication({ store, $axios }))
}