<template>
<div>
  <AnimatedDrawSection
    ref="animate"
    :draw-result="result"
    :names="names"
    gatherStatus="ungathered"/>
</div>
</template>

<script>
import api from "@/api";
import AnimatedDrawSection from "@/components/AnimatedDrawSection";
export default {
  name: "Replay",
  refs: {animate: AnimatedDrawSection},
  components: {AnimatedDrawSection},
  data: function() {
    return {
    result: {},
    names: [],
    errors: []
  }
  },
  created: function() {
    api.get(`results?id=${this.$route.params.id}`)
        .then(r => {
          this.result = r.data.result;
          this.names = Object.keys(r.data.result)
          setTimeout(() => {
            this.$refs.animate.toggleGather()
          }, 1000)
          setTimeout(() => {
            this.$refs.animate.pullCardsFromHat()
          }, (2000 + this.$refs.animate.animationTime))
        })
        .catch(e => this.errors.push(e))
  }

}
</script>

<style scoped>

</style>