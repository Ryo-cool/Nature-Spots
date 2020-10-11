<template>
  <v-container class="my-7">
    <v-row justify="center">
      <v-col cols="11" md="7" sm="8">
        <h1 class="text-center">口コミを投稿する</h1>
        <h2>総合評価</h2>
        <v-divider class="mb-2"></v-divider>
        <v-rating
          v-model="rating"
          background-color="purple lighten-3"
          color="purple"
          large
          hover
        ></v-rating>
        <h2>口コミ</h2>
        <v-divider class="mb-4"></v-divider>
        <h4>タイトル(◯文字以内)</h4>
        <v-text-field
          
          placeholder="感想や思い出に残ったことをまとめましょう"
          outlined
        ></v-text-field>
        <h4>内容(◯文字以内)</h4>
        <v-textarea
          outlined
          placeholder="日本でも有名な温泉街で、日帰りで友人と車で出かけました。着いた時から硫黄の香りと湯けむりで、ワクワクしました。なにより温泉街はとても心地よく、浴衣でまち歩きをしながら食べたり、お店にも立ち寄ったりすることができます。温泉にもゆっくり浸かることができ、大満足でした。"
        ></v-textarea>
        <h2>写真</h2>
        <v-divider class="mb-4"></v-divider>
        <img v-if="uploadImageUrl" :src="uploadImageUrl" />
        <v-file-input
          v-model="input_image"
          accept="image/*"
          show-size
          counter
          label="File input"
          @change="onImagePicked"
        ></v-file-input>
        <h2>行った時期</h2>
        <v-divider class="mb-4"></v-divider>
        <v-row justify="center">
          <v-date-picker
            v-model="picker"
            type="month"
            locale="jp"
          ></v-date-picker>
        </v-row>
        <v-divider class="mb-2"></v-divider>
        <v-row justify="center">
          <v-btn color="success" dark min-width="300" >
            投稿する
          </v-btn>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data () {
    return {
      picker: new Date().toISOString().substr(0, 10),
      input_image: null,
      uploadImageUrl: ''
    }
  },
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },
  methods: {
    onImagePicked(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf('.') <= 0) {
          return
        }
        const fr = new FileReader()
        fr.readAsDataURL(file)
        fr.addEventListener('load', () => {
          this.uploadImageUrl = fr.result
        })
      } else {
        this.uploadImageUrl = ''
      }
    }
  }
}
</script>

<style>
h2 {
  margin: 15px 0 3px 0;
}

</style>