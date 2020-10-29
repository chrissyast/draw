<template>
  <div>
    <p v-for="(buyer,recipient) in results">
      <b>{{buyer}}</b> will buy for <b>{{recipient}}</b>
    </p>
 <!--   <button v-on:click="shareResults">Share!</button>-->
  </div>
</template>

<script>
export default {
  name: "ResultSection",
  props: {
    results: Object
  },
  methods: {
    shareResults() {

    }
  }
}
</script>

<style scoped>

</style>