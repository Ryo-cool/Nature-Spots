<template>
  <v-container>
    <v-row>
      <v-col>
        <h1>検索</h1>
        <v-img
          :src="homeImg"
          alt="homeImg"
          aspect-ratio="2.8"
          contain
        >
          <v-container
            fill-height
          >
          <h1>行き先は？</h1>
            <v-row
              justify="center"
              align="center"
            >
              
              <v-col
                cols="9"
                sm="6"
              >
                <!-- コンポーネント化したい -->
                <v-form>
                  
                  <v-text-field
                    label="Search"
                    solo
                    prepend-inner-icon="mdi-magnify"
                  >
                  </v-text-field>
                </v-form>
              </v-col>
            </v-row>
          </v-container>
        </v-img>
      </v-col>
    </v-row>
    <v-row
    class="mt-6"
    > 

      <japan />
      <category />
    </v-row>
    <v-row>
      <v-col>
        <h1>人気のスポット一覧</h1>
        <v-item-group mandatory>
          <v-container>
            <v-row>
              <v-col
                v-for="n in 3"
                :key="n"
                cols="12"
                md="4"
              >
                <v-item v-slot:default="{ active, toggle }">
                  <v-card
                    :color="active ? 'primary' : ''"
                    class="d-flex align-center"
                    dark
                    height="200"
                    @click="toggle"
                  >
                    <v-scroll-y-transition>
                      <div
                        v-if="active"
                        class="display-3 flex-grow-1 text-center"
                      >
                        Active
                      </div>
                    </v-scroll-y-transition>
                  </v-card>
                </v-item>
              </v-col>
            </v-row>
          </v-container>
        </v-item-group>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <h1>いきたいリスト</h1>
          <v-sheet
            class="mx-auto mt-8 mb-16"
            elevation="8"
            
          >
            <v-slide-group
              v-model="model"
              class="pa-4"
              center-active
              show-arrows
            >
              <v-slide-item
                v-for="n in 15"
                :key="n"
                v-slot:default="{ active, toggle }"
              >
                <v-card
                  :color="active ? 'primary' : 'grey lighten-1'"
                  class="ma-4"
                  height="200"
                  width="200"
                  @click="toggle"
                >
                  <v-row
                    class="fill-height"
                    align="center"
                    justify="center"
                  >
                    <v-scale-transition>
                      <v-icon
                        v-if="active"
                        color="white"
                        size="48"
                        v-text="'mdi-close-circle-outline'"
                      ></v-icon>
                    </v-scale-transition>
                  </v-row>
                </v-card>
              </v-slide-item>
            </v-slide-group>
          </v-sheet>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import homeImg from '~/assets/images/loggedIn/surfing_monochromatic.png'

export default {
  data () {
    return {
      homeImg
    }
  },
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  }
}
</script>