<template>
  <div id="app">
    <input-section @submit="handleSubmit"/>
    <div v-if="showResults">
      <results-section :names="names"/>
    </div>
  </div>
</template>

<script>
import InputSection from "./components/InputSection";
export default {
  name: 'App',
  components: {InputSection},
  methods: {
    handleSubmit(results) {
      debugger;
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
