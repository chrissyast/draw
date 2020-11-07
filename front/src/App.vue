<template>
  <div id="app">
    <v-app>
      <router-view></router-view>
    </v-app>
  </div>
</template>

<script>

import Main from "@/pages/main";

export default {
  name: "App",
  components: {Main}
}
</script>

<style lang="scss" scoped>

#app {
font-family: "Avenir", Helvetica, Arial, sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
text-align: center;
color: #2c3e50;
margin-top: 60px;
padding-right: 10px;
}
</style>