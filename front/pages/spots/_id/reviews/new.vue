<template>
  <v-container class="my-7">
    <v-row justify="center">
      <v-col cols="11" md="7" sm="8">
        <h1 class="text-center">口コミを投稿する</h1>
        <h2>総合評価</h2>
        <v-divider class="mb-2" />
        <v-rating
          v-model="rating"
          background-color="purple lighten-3"
          color="purple"
          large
          hover
        />
        <h2>口コミ</h2>
        <v-divider class="mb-4" />
        <h4>タイトル(◯文字以内)</h4>
        <v-text-field
          v-model="title"
          placeholder="感想や思い出に残ったことをまとめましょう"
          outlined
        />
        <h4>内容(◯文字以内)</h4>
        <v-textarea
          v-model="text"
          outlined
          placeholder="日本でも有名な温泉街で、日帰りで友人と車で出かけました。着いた時から硫黄の香りと湯けむりで、ワクワクしました。なにより温泉街はとても心地よく、浴衣でまち歩きをしながら食べたり、お店にも立ち寄ったりすることができます。温泉にもゆっくり浸かることができ、大満足でした。"
        />
        <h2>写真</h2>
        <v-divider class="mb-4" />
        <!-- 画像プレビュー -->
        <v-img :src="preview" max-width="300" />
        <v-file-input
          accept="image/png, image/jpeg, image/bmp"
          show-size
          counter
          label="File input"
          @change="setImage"
        />
        <h2>行った時期</h2>
        <v-divider class="mb-4" />
        <v-row justify="center">
          <v-date-picker v-model="picker" type="month" locale="jp" />
        </v-row>
        <v-divider class="mb-2" />
        <v-row justify="center">
          <v-btn
            color="primary"
            dark
            min-width="300"
            :disabled="!allInput"
            :loading="loading"
            @click="createReview"
          >
            投稿する
          </v-btn>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  layout({ $auth }) {
    return $auth.loggedIn ? "loggedIn" : "welcome";
  },
  data() {
    return {
      // picker: new Date().toISOString().substr(0, 10),
      rating: null,
      title: "",
      text: "",
      picker: "",
      image: null,
      preview: "",
      spots: [],
      reviews: [],
      id: [],
      loading: false,
    };
  },
  computed: {
    // すべてインプット後に投稿ボタンを押せるようにする
    allInput() {
      const requiredFields = ["title", "text", "picker", "rating"];
      return !requiredFields.includes("");
    },
  },
  created() {
    this.$axios

      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        // const spot = res.data
        this.spots = res.data;
        this.id = res.data.id;
        // this.review = res.data.review
      })
      .catch((error) => {
        console.error(error);
      });
  },
  methods: {
    setImage(e) {
      this.image = e;
      this.preview = URL.createObjectURL(e);
    },
    createReview() {
      this.loading = true;
      const formData = new FormData();
      formData.append("title", this.title);
      formData.append("text", this.text);
      formData.append("image", this.image);
      formData.append("wentday", this.picker);
      formData.append("rating", this.rating);
      formData.append("spot_id", this.id);
      formData.append("user_id", this.$auth.user.id);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      this.$axios
        .post(
          `/api/v1/spots/${this.$route.params.id}/reviews/`,
          formData,
          config,
        )
        .then((res) => {
          this.$router.push("/");
          if (res.data) {
            this.reviews.push(res.data);
          }
        })
        .catch((error) => console.log(error));
    },
  },
};
</script>

<style>
h2 {
  margin: 15px 0 3px 0;
}
</style>
