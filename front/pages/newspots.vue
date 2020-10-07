<template>
  <v-container>
    <v-row>
      <v-col
      cols ="12"
      sm="6"
      class="my-6 text-center"
      align-self="start"
      >
        <v-text-field
        label="スポット名"
        v-model="name"
        prepend-icon=""
        type="text"
        />
        <v-text-field
        label="説明"
        v-model="introduction"
        prepend-icon=""
        type="text"
        />
        <img v-if="uploadImageUrl" :src="uploadImageUrl" />
        <v-file-input
          chips
          small-chips
          show-size
          v-model="photo"
          accept="image/png, image/jpeg, image/bmp"
          prepend-icon="mdi-camera"
          @change="onImagePicked"
          
        />
        <v-btn color="primary" @click="createSpot">ADD post</v-btn>
      </v-col>
      <v-col
      cols ="12"
      sm="6"
      >
        <v-card
          class="mx-auto"
          
          tile
        >
            <v-list rounded>
              <v-subheader>SPOTS</v-subheader>
              <v-list-item-group color="primary">
                <v-list-item
                  v-for="spot in spots"
                  :key="spots.id"
                  @click=""
                >
                  <v-list-item-content>
                    <v-list-item-title v-text="spot.name"></v-list-item-title>
                    <v-list-item-title v-text="spot.introduction"></v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>


<script>
import axios from "~/plugins/axios"

export default {
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },
  data () {
    return {
      name: "",
      introduction: "",
      photo:null,
      uploadImageUrl: '',
      spots: []
    }
  },
  created() {
    // ユーザーをaxiosで取得
    axios.get("/api/v1/spots").then(res => {
      if (res.data) {
        this.spots = res.data
      }
    })
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
    },
     // ユーザーをaxiosで登録
    createSpot(){
      axios.post("/api/v1/spots", {name: this.name,introduction: this.introduction,photo: this.photo}).then(res => {
        if (res.data) {
            this.spots.push(res.data)
        }
      })
    }
  }
}
</script>

<style>

</style>