<template>
  <v-col
    cols="12"
    md="6"
  >
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-img
        :src="homeImg"
        aspect-ratio="1.3"
        contain
      >
        <v-container>
          <v-row >
            <v-col
              cols="4"
            >
              <h3>北海道・東北</h3>
                <div>北海道</div>
                <div>青森</div>
                <div>秋田</div>
                <div>岩手</div>
                <div>山形</div>
                <div>宮城</div>
                <div>福島</div>
            </v-col>
            <v-col
              cols="2"
            >
              <h3>関東</h3>
                <div>群馬</div>
                <div>栃木</div>
                <div>茨城</div>
                <div>埼玉</div>
                <div>千葉</div>
                <div>東京</div>
                <div>神奈川</div>
            </v-col>
          </v-row>
        </v-container>
          </v-row>
        </v-container>
      </v-img>
    </v-card>
  </v-col>
</template>

<script>
import homeImg from '~/assets/images/loggedIn/japanesemap.png'
export default {
  data () {
    return {
      homeImg
    }
  }
}
</script>