<template>
<div>
  {{ result }}
</div>
</template>

<script>
import api from "@/api";
export default {
  name: "Replay",
  data: function() {
    return {
    result: {}
  }
  },
  created: function() {
    api.get(`results/${this.$route.params.id}`)
        .then(r => {
          this.result = r.data;
        })
        .catch(e => console.log(e))
  }

}
</script>

<style scoped>

</style>