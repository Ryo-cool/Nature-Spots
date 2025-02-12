<template>
  <v-col cols="12" md="7" class="hidden-ipad-and-up">
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-list>
        <v-list-group v-model="active" :value="true" no-action>
          <template #activator>
            <v-list-item-content>
              <v-list-item-title>都道府県一覧</v-list-item-title>
            </v-list-item-content>
          </template>

          <v-list-item
            v-for="prefecture in prefectures"
            :key="prefecture.name"
            v-model="active"
            link
            :to="`prefecture/${prefecture.attributes.id}`"
          >
            <v-list-item-title v-text="prefecture.attributes.name" />
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-card>
  </v-col>
</template>

<script>
import Vue from "vue";
import { Component } from "vue-property-decorator";

@Component({
  data() {
    return {
      prefectures: [],
      active: false,
    };
  },
  mounted() {
    this.$axios
      .get("api/v1/prefectures")
      .then((res) => {
        this.prefectures = res.data;
      })
      .catch((error) => {
        console.error(error);
      });
  },
})
export default class JapanList extends Vue {
  // ... existing code ...
}
</script>
