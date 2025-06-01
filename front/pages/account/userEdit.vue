<template>
  <v-container>
    <v-form>
      <v-row>
        <v-col cols="3">
          <v-text-field v-model="user.name" label="ユーザー名" />
        </v-col>
        <v-col cols="3">
          <v-text-field v-model="user.introduction" label="自己紹介文" />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="6">
          <v-img :src="preview" />
          <v-file-input
            v-model="user.image"
            chips
            small-chips
            show-size
            label="画像(任意)"
            accept="image/png, image/jpeg, image/bmp"
            prepend-icon="mdi-camera"
            @change="setImage"
          />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="3">
          <v-btn color="primary" @click="editSpot"> 登録する </v-btn>
        </v-col>
      </v-row>
    </v-form>
  </v-container>
</template>

<script>
export default {
  layout({ $auth }) {
    return $auth.loggedIn ? "loggedIn" : "welcome";
  },
  data() {
    return {
      user: "",
      preview: null,
    };
  },
  mounted() {
    this.$axios
      .get(`/api/v1/users/${this.$auth.user.id}`)
      .then((res) => {
        this.user = res.data;
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
    editSpot() {
      const formData = new FormData();
      formData.append("name", this.user.name);
      formData.append("introduction", this.user.introduction);
      formData.append("image", this.user.image);
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      this.$axios
        .put(`/api/v1/users/${this.$auth.user.id}`, formData, config)
        .then((res) => {
          if (res.data) {
            this.$router.push("/");
          }
        });
    },
  },
};
</script>
