<template>
  <transition name="fade" mode="out-in">
    <div v-if="!drawFinished">
      <div
          class="cardStack container"
          style="height: 80vh; position: relative"
      >
        <CardStack
            :gatherStatus="gatherStatus"
            :showLoading="showLoading"
            :names="names"
            v-on:remove="remove"
            ref="stack"
        />
      </div>
    </div>
    <result-section
        v-if="drawFinished"
        :results="drawResult"
        :id="drawId"
    />
  </transition>
</template>

<script>
import CardStack from "../components/CardStack.vue";
import ResultSection from "../components/ResultSection";
export default {
  name: "AnimatedDrawSection",
  components: {CardStack, ResultSection},
  refs: {stack: CardStack},
  data: function () { return {
    timeouts: [],
    gatherStatus: "ungathered",
    drawFinished: false
  }},
  props: {
    names: Array,
    drawResult: Object,
    drawId: Number,
    showLoading: Boolean
  },
  computed: {
    animationTime() {
      return parseInt(this.$style.gatheringTime.split("ms")[0], 10) +
          parseInt(this.$style.putAwayTime.split("ms")[0], 10);
    }
  },
  methods:{
    remove(index) {
      this.$emit("remove",index)
    },
    selectCard(buyer, recipient, index) {
      this.$refs.stack.selectCard(buyer, recipient, index)
    },
    toggleGather() {
      this.drawInProgress = !this.drawInProgress;
      if (this.gatherStatus === "ungathered") {
        this.gatherStatus = "gathering";
        const animationTime = this.animationTime;
        this.timeouts.push(setTimeout(() => {
          this.gatherStatus = "gathered"
        }, animationTime))
      } else {
        this.gatherStatus = "ungathered";
        this.$refs.stack.$refs.cards.forEach(c => c.selected = false)
      }
    },
    clearAnimations() {
      for (var timeout in this.timeouts) {
        clearTimeout(this.timeouts[timeout]);
      }
      this.$refs.stack.selectedBuyer = '';
    },
    pullCardsFromHat() {
      var i = 0;
      let delay = this.$style.nextCardDelay;
      for (const [buyer, recipient] of Object.entries(this.drawResult)) {
        let index = i;
        this.timeouts.push(
            setTimeout(() => {
              this.$refs.stack.selectCard(buyer, recipient, index);
            }, delay * i)
        );
        i++;
      }
      this.timeouts.push(
          setTimeout(() => {
            this.drawFinished = true;
            this.$emit("drawOver")
          }, delay * i + 1000)
      );
    }
  }
}
</script>

<style module lang="scss">
@import "src/styles/variables";
:export {
  maxUngathered: $maximum-ungathered-cards;
  gatheringTime: $gathering-time;
  putAwayTime: $put-away-time;
  nextCardDelay: $next-card-delay;
}
</style>

<style lang="scss" scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>