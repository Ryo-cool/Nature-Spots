<template>
  <v-card class="mt-10">
    <v-toolbar flat color="green lighten-4">
      <v-avatar size="120">
        <v-img :src="photo" />
      </v-avatar>
      <v-toolbar-title class="ml-4">
        {{ $auth.user.name }}さん
      </v-toolbar-title>
      <nuxt-link to="userEdit" class="text-decoration-none">
        <v-btn class="ml-5" rounded>
          <v-icon>mdi-pencil</v-icon>
          プロフィール編集
        </v-btn>
      </nuxt-link>
    </v-toolbar>

    <v-tabs>
      <v-tab>
        <v-icon left>
mdi-account
</v-icon>
        投稿したレビュー({{ myReview.length }})
      </v-tab>
      <v-tab>
        <v-icon left>
mdi-heart
</v-icon>
        いいねしたレビュー({{ reviews.length }})
      </v-tab>
      <v-tab>
        <v-icon left>
mdi-access-point
</v-icon>
        お気に入りスポット({{ likeSpot.length }})
      </v-tab>
      <v-tab>
        <v-icon left>
mdi-account-multiple
</v-icon>
        フォロー ({{ followUser.length }})
      </v-tab>
      <v-tab>
        <v-icon left>
mdi-account-multiple
</v-icon>
        フォロワー ({{ follower.length }})
      </v-tab>
      <v-tab-item>
        <v-row class="mx-2">
          <v-col v-for="s in myReview" :key="s.id" cols="12" md="4" sm="6">
            <v-card>
              <v-img :src="s.image.url" :aspect-ratio="12 / 9" />
              <nuxt-link
                :to="`/spots/${s.spot.id}`"
                class="text-decoration-none"
              >
                <v-card-title class="pb-0">
                  {{ s.spot.name }}
                </v-card-title>
              </nuxt-link>
              <v-card-text class="pb-1">
                <v-row>
                  <v-rating v-model="s.rating" readonly />
                  <span class="grey--text body-1 mr-2 pt-2">
                    ({{ s.rating }})
                  </span>
                </v-row>
              </v-card-text>
              <v-card-title class="py-1">
                {{ s.title }}
              </v-card-title>
              <v-card-text>{{ s.text }}</v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-tab-item>
      <v-tab-item>
        <v-row>
          <v-col v-for="i in reviews" :key="i.id" cols="12" md="4" sm="6">
            <v-card>
              <v-card-text>
                <v-row>
                  <v-col cols="2" class="py-0">
                    <nuxt-link
                      :to="`/user/${i.user.id}`"
                      class="text-decoration-none"
                    >
                      <v-avatar size="36">
                        <v-img :src="i.user.image.url" />
                      </v-avatar>
                    </nuxt-link>
                  </v-col>
                  <v-col>
                    <div>{{ i.user.name }}さんの投稿</div>
                  </v-col>
                </v-row>
              </v-card-text>
              <v-img :src="i.image.url" :aspect-ratio="12 / 9" />
              <nuxt-link
                :to="`/spots/${i.spot.id}`"
                class="text-decoration-none"
              >
                <v-card-title class="pb-0">
                  {{ i.spot.name }}
                </v-card-title>
              </nuxt-link>
              <v-card-text class="pb-1">
                <v-row>
                  <v-rating v-model="i.rating" readonly />
                  <span class="grey--text body-1 mr-2 pt-2">
                    ({{ i.rating }})
                  </span>
                </v-row>
              </v-card-text>
              <v-card-title>{{ i.title }}</v-card-title>
              <v-card-text>{{ i.text }}</v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-tab-item>
      <v-tab-item>
        <v-card flat>
          <v-card-text v-for="a in likeSpot" :key="a.id">
            <v-img
              :src="a.photo.url"
              :aspect-ratio="16 / 9"
              max-height="200"
              max-width="250"
            />
            <nuxt-link :to="`/spots/${a.id}`" class="text-decoration-none">
              <v-card-title>{{ a.name }}</v-card-title>
            </nuxt-link>
          </v-card-text>
        </v-card>
      </v-tab-item>
      <v-tab-item>
        <v-card flat>
          <v-card-text v-for="v in followUser" :key="v.id">
            <v-avatar size="100">
              <v-img :src="v.image.url" />
            </v-avatar>
            <nuxt-link :to="`/user/${v.id}`" class="text-decoration-none">
              <v-card-title>{{ v.name }}</v-card-title>
            </nuxt-link>
            <follow-btn />
          </v-card-text>
        </v-card>
      </v-tab-item>
      <v-tab-item>
        <v-card flat>
          <v-card-text v-for="t in follower" :key="t.id">
            <v-avatar size="100">
              <v-img :src="t.image.url" />
            </v-avatar>
            <nuxt-link :to="`/user/${t.id}`" class="text-decoration-none">
              <v-card-title>{{ t.name }}</v-card-title>
            </nuxt-link>
            <follow-btn />
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      tab: null,
      reviews: {},
      myReview: {},
      likeSpot: {},
      followUser: {},
      follower: {},
      user: {},
      photo: null,
    };
  },
  mounted() {
    this.$axios
      .get(`/api/v1/users/user_data`)
      .then((res) => {
        this.user = res.data.user;
        this.photo = res.data.user.image.url;
        this.reviews = JSON.parse(res.data.like_reviews);
        this.myReview = JSON.parse(res.data.review);
        this.likeSpot = res.data.favorite;
        this.followUser = res.data.follow;
        this.follower = res.data.follower;
      })
      .catch((error) => {
        console.error(error);
      });
  },
};
</script>
