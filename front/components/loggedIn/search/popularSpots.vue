<template>
    <v-slide-group
      v-model="model"
      class="pa-4"
      prev-icon="mdi-arrow-left-circle-outline"
      next-icon="mdi-arrow-right-circle-outline"
    >
      <v-slide-item
        v-for="n in 8"
        :key="n"
        v-slot="{ active, toggle }"
      >
        <v-card
          :color="active ? 'primary' : 'grey lighten-1'"
          class="ma-4"
          height="200"
          width="250"
          @click="toggle"
        >
          アイテム{{ n }}
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

</template>

<script>
  export default {
    data: () => ({
      model: null,
    }),
  }
</script>