<template>
  <div class="page">
    <div 
      class="top"
      @click="down"
    >
      TOP
    </div>
    <div
      class="bottom"
      @click="top"
    >
      BOTTOM
    </div>
    <transition name="button">
      <button
        v-show="buttonActive"
        class="button"
        @click="top"
      />
    </transition>
  </div>
</template>

<script>
export default {
  mounted() {
    window.addEventListener('scroll', this.comeButton)
  },
  data () {
    return {
      buttonActive: false,
      scroll: 0,
    }
  },
  methods: {
    top () {
      window.scrollTo ({
        top: 0,
        behavior: "smooth"
      })
    },
    down () {
      window.scrollTo ({
        top: 900,
        behavior: "smooth"
      })
    },
    comeButton () {
      // console.log(`Y軸${window.scrollY}`)
      const top = 30
      this.scroll = window.scrollY
      if (top <= this.scroll) {
        this.buttonActive = true
      } else {
        this.buttonActive = false
      }
    },
  },
}
</script>

<style lang="scss" scoped>
  .page {
    font-size: 32px;

    > .bottom {
      margin-top: 1000px;
    }

    > .button {
      position: fixed;
      bottom: 30px;
      right: 30px;
      width: 50px;
      height: 50px;
      background-color: pink;
      border-radius: 50%;
      background-image: url('data:image/svg+xml, <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="%23ffffff" d="M0 16.67l2.829 2.83 9.175-9.339 9.167 9.339 2.829-2.83-11.996-12.17z"/></svg>');
      background-repeat: no-repeat;
      background-size: 20px;
      background-position: center;

      &.button-enter-active,
      &.button-leave-active {
        transition: opacity 0.5s;
      }
      &.button-enter,
      &.button-leave-to {
        opacity: 0;
      }
    }
  }
</style>