<template>
  <v-container>
    <v-form>
      <v-row>
        <v-col cols="3">
          <v-text-field
            v-model="user.name"
            label="ユーザー名"
          >
          </v-text-field>
        </v-col>
        <v-col cols="3">
          <v-text-field
            v-model="user.introduction"
            label="自己紹介文"
          >
          </v-text-field>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="6">
        <v-img :src="preview"/>
        <v-file-input
          chips
          small-chips
          show-size
          v-model="user.image"
          @change="setImage"
          label="画像(任意)"
          accept="image/png, image/jpeg, image/bmp"
          prepend-icon="mdi-camera"
        />
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="3">
          <v-btn
            color="primary" @click="editSpot"
          >
            登録する
          </v-btn>
        </v-col>
      </v-row>
    </v-form>
  </v-container>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data(){
    return{
      user: "",
      preview: null
    }
  },
  layout ({ $auth }) {
    return $auth.loggedIn ? 'loggedIn' : 'welcome'
  },
  mounted(){
    this.$axios
      .get(`/api/v1/users/${this.$auth.user.id}`)
      .then((res) => {
        this.user = res.data
      })
      .catch((error) => {
        console.error(error)
      })
  },
  methods:{
    setImage(e){
      this.image = e;
      this.preview = URL.createObjectURL(e);
    },
    editSpot(){
      const formData = new FormData();
      formData.append("name", this.user.name);
      formData.append("introduction", this.user.introduction);
      formData.append("image", this.user.image);
      const config = {
          headers: {
              "content-type": "multipart/form-data",
          }
      };
      this.$axios.put(`/api/v1/users/${this.$auth.user.id}`, 
        formData,config
      )
      .then(res => {
        if (res.data) {
          this.spots.push(res.data)
          this.$router.push('/')
        }
      })
    }
  }
}
</script>