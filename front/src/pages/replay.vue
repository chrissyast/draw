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
    names: []
  }
  },
  created: function() {
    api.get(`results/${this.$route.params.id}`)
        .then(r => {
          this.result = r.data.result;
          this.names = Object.keys(r.data.result)
          setTimeout(() => {
            this.$refs.animate.toggleGather()
            this.$refs.animate.animateDraw()
          }, 1000)
        })
        .catch(e => console.log(e))
  }

}
</script>

<style scoped>

</style>