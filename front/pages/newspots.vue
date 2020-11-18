<template>
  <v-container>
    <v-row>
      <v-col
      cols ="12"
      sm="6"
      class="my-6 text-center"
      align-self="start"
      >
        <h1 class="mb-4">スポット投稿</h1>
        <div class="red--text">{{ alert }}</div>

        <v-text-field
        label="スポット名(必須)"
        v-model="name"
        prepend-icon=""
        type="text"
        outlined
        @change="onChange"
        />

        <div>緯度{{ lat }}</div>
        <div>{{ locations }}</div>
        <div>{{ address }}</div>

        <v-text-field
        label="説明(必須)"
        v-model="introduction"
        prepend-icon=""
        type="text"
        outlined
        />

        <v-file-input
          chips
          small-chips
          show-size
          label="画像(任意)"
          accept="image/png, image/jpeg, image/bmp"
          prepend-icon="mdi-camera"
        />
        <v-select
        label="都道府県(必須)"
        v-model= "prefectures"
        item-text="attributes.name"
        item-value="attributes.id"
        :items="prefecture"
        outlined
        />

        <v-text-field
        label="住所(必須)"
        v-model="address"
        prepend-icon=""
        type="text"
        outlined
        />

        <v-select
        label="ジャンル(必須)"
        v-model= "locations"
        item-text="attributes.name"
        item-value="attributes.id"
        :items="location"
        outlined
        />
        <v-btn color="primary" @click="createSpot" :disabled="!isValid" 
        >スポットを投稿する</v-btn>
        
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
                    <nuxt-link
                    :to="$my.spotLinkTo(spot.id)"
                    class="text-decoration-none"
                    >
                    <v-list-item-title v-text="spot.id"></v-list-item-title>
                    <v-list-item-title v-text="spot.name"></v-list-item-title>
                    </nuxt-link>
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
  layout ({ $auth }) {
    return $auth.loggedIn ? 'loggedIn' : 'welcome'
  },
  data () {
    return {
      
      name: "",
      introduction: "",
      prefectures: "",
      address: "",
      locations: "",
      lat: "",
      lng: "",
      alert: "",
      // uploadImageUrl: '',
      geocoder: {},
      spots: [],
      prefecture: [],
      location: []
    }
  },
  computed: {
    isValid () {
      const required_fields = [
        this.name,
        this.introduction,
        this.prefecture,
        this.address,
        this.locations,
      ]
      return required_fields.indexOf('') === -1
    },
  },
  mounted() {
    this.$axios.get("/api/v1/spots").then(res => {
      if (res.data) {
        this.spots = res.data.spots
        this.prefecture = res.data.prefecture
        this.location = res.data.location
      }
    }),
    this.$gmapApiPromiseLazy().then(() => {this.geocoder = new google.maps.Geocoder() })
  },
  // created() {
  //   // ユーザーをaxiosで取得
  //   axios.get("/api/v1/spots").then(res => {
  //     if (res.data) {
  //       this.spots = res.data.spots
  //       this.prefecture = res.data.prefecture
  //       this.location = res.data.location
  //     }
  //   })
  // },
  methods: {
    // onImagePicked(file) {
    //   if (file !== undefined && file !== null) {
    //     if (file.name.lastIndexOf('.') <= 0) {
    //       return
    //     }
    //     const fr = new FileReader()
    //     fr.readAsDataURL(file)
    //     fr.addEventListener('load', () => {
    //       this.uploadImageUrl = fr.result
    //     })
    //   } else {
    //     this.uploadImageUrl = ''
    //   }
    // },
    // 入力されたスポット名を住所変換
    onChange() {
      this.geocoder.geocode({
        'address': this.name
      },(results, status) =>{
        if(status === google.maps.GeocoderStatus.OK) {
          this.alert = ""
          this.lat = results[0].geometry.location.lat();
          this.lng = results[0].geometry.location.lng();
          var ad = results[0].formatted_address.replace('日本、', '');
          this.address = ad
        }
        else{
          
        }
      }
      )
    },
     // スポットをaxiosで登録
    createSpot(){
      this.$axios.post("/api/v1/spots", 
      {
        name: this.name,
        introduction: this.introduction,
        prefecture_id: this.prefectures,
        address: this.address,
        location_id: this.locations,
        latitude: this.lat,
        longitude: this.lng
      })
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

<style>

</style>