<template>
  <v-container class="grey lighten-2 pt-9">
    <v-card>
      <v-container>
        <v-row>
          <user-data />
          <follow-btn />
        </v-row>
      </v-container>
    </v-card>

    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <user-reviews />
        </v-col>
      </v-row>
    </v-container>
  </v-container>
</template>

<script>
export default {
  layout({ $auth }) {
    return $auth.loggedIn ? "loggedIn" : "welcome";
  },
};
</script>
