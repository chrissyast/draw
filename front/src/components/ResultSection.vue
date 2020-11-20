<template>
  <div>
    <p style="font-size: 20px" v-for="(buyer,recipient) in results">
      <b>{{buyer}}</b> will buy for <b>{{recipient}}</b>
    </p>
    <div style="padding-bottom: 5px">
      <v-btn v-if="showShareButton" v-on:click="shareResults">Share with friends...</v-btn>
    </div>
    <br>
    <p v-if="showShareUrl">
      <b>{{shareURL}}</b> copied to clipboard!
      <br>Email function coming soon!<br>
    </p>
  </div>
</template>

<script>

// TODO implement email

export default {
  name: "ResultSection",
  data: function () {
    return {
      showShareUrl: false
    }
  },
  computed: {
    showShareButton() {
      return this.$route.path.indexOf("replay") == -1
    },
    shareURL() {
      return `${window.location.href}replay/${this.id}`
    }
  },
  props: {
    results: Object,
    id: Number
  },
  created: function () {

  },
  methods: {
    shareResults() {
      this.showShareUrl = true;

      /* copy url to clipboard */
      var dummy = document.createElement("textarea");
      document.body.appendChild(dummy);
      dummy.value = this.shareURL;
      dummy.select();
      document.execCommand("copy");
      document.body.removeChild(dummy);
    }
  }
}
</script>

<style scoped>

</style>