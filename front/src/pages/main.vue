<template>
  <div class="main container">
    <InputSection ref="input"
                  :names="names"
                  :showValidation="showValidation"
                  :drawInProgress="drawInProgress"
                  v-if="!(drawInProgress || drawFinished)"
                  v-on:add="add"
                  v-on:calculate="calculate"
                  v-on:cancel="cancel"
    />
    <v-btn class="submit-button" style="width:25%" v-if="drawInProgress" @click="cancel">Cancel</v-btn>
    <transition name="fade" mode="out-in">
      <div v-if="!drawFinished">
        <div
            class="cardStack container"
            style="height: 80vh; position: relative"
        >
          <CardStack
              :gatherStatus="gatherStatus"
              :names="names"
              v-on:remove="remove"
              ref="stack"
          />
        </div>
      </div>
      <result-section
          v-if="drawFinished"
          :results="drawResult">
      </result-section>
    </transition>
  </div>
</template>

<script>

import InputSection from "../components/InputSection.vue";
import Card from "../components/Card.vue";
import CardStack from "../components/CardStack.vue";
import ResultSection from "../components/ResultSection";
import API from "../api.js";

export default {
  name: "Main",
  data: function () {
    return {
      names: [],
      gatherStatus: "ungathered",
      showValidation: false,
      drawInProgress: false,
      drawFinished: false,
      displaySummary: false,
      timeouts: [],
      drawResult: {},
    };
  },
  refs: { stack: CardStack, input: InputSection },
  components: {Card, CardStack, InputSection, ResultSection },
  beforeCreate: function () {
    document.body.style = "overflow: visible";
    document.documentElement.style.setProperty(
        "overflow",
        "visible",
        "important"
    );
  },
  methods: {
    toggleGather() {
      this.drawInProgress = !this.drawInProgress;
      if (this.gatherStatus === "ungathered") {
        this.gatherStatus = "gathering";
      } else {
        this.gatherStatus = "ungathered";
        this.$refs.stack.$refs.cards.forEach(c => c.selected = false)
      }
    },
    animateDraw() {
      var animationTime =
          parseInt(this.$style.gatheringTime.split("ms")[0], 10) +
          parseInt(this.$style.putAwayTime.split("ms")[0], 10);
      this.timeouts.push(setTimeout(this.startDraw, animationTime));
    },
    cancel() {
      this.toggleGather();
      for (var timeout in this.timeouts) {
        clearTimeout(this.timeouts[timeout]);
      }
      this.$refs.stack.selectedBuyer = '';
    },
    colour(index = 0) {
      if (!(Math.floor(index / 6) % 2))
        return this.colours['--secondary-colour']
      else return this.colours['--main-colour']
    },
    calculate() {
      this.toggleGather();
      const body = {"people": this.names};
      API.post("calculation", body)
          .then(response => {
            this.drawResult = response.data.result;
            this.showResults = true
            this.animateDraw();
          })
          .catch(e => {
            this.errors.push(e)
          })
    },
    startDraw() {
      this.gatherStatus = "gathered";
      var i = 1;
      let delay = this.$style.nextCardDelay;
      for (const [buyer, recipient] of Object.entries(this.drawResult)) {
        let foo = i;

        this.timeouts.push(
            setTimeout(() => {
              this.$refs.stack.selectCard(buyer, recipient, foo);
            }, delay * i)
        );
        i++;
      }
      this.timeouts.push(
          setTimeout(() => {
            this.drawFinished = true;
            this.drawInProgress = false;
          }, delay * i + 1000)
      );
    },
    add(event) {
      this.showValidation = false;
      if (event == '') {

      }
      else if (this.names.includes(event.toString())){
        this.showValidation = true;
      }
      else {
        this.names.push(event.toString());
        // TODO make this into a prop
        this.$refs.input.person = '';
        this.showResults = false;
      }
    },
    remove(index) {
      this.names.splice(index, 1)
    }
  },
  computed: {

  },
};
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

.main {
  width: 100%;
  position: relative;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}
</style>
