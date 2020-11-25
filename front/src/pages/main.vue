<template>
  <div class="main container">
    <InputSection
        ref="input"
        :names="names"
        :showValidation="showValidation"
        :drawInProgress="drawInProgress"
        v-if="!(drawInProgress || drawFinished)"
        v-on:add="add"
        v-on:calculate="calculate"
        v-on:cancel="cancel"
    />
<!--     TODO add loading bar v-if showLoading-->
    <v-btn class="submit-button" style="width:25%" v-if="drawInProgress" @click="cancel">Cancel</v-btn>
    <animated-draw-section
       ref="animation"
       :names="names"
       :draw-result="drawResult"
       :showLoading="showLoading"
       :drawId="drawId"
       :drawFinished="drawFinished"
       v-on:remove="remove"
       v-on:drawOver="updateDrawFinished"
    />
  </div>
</template>

<script>

import InputSection from "../components/InputSection.vue";
import Card from "../components/Card.vue";

import AnimatedDrawSection from "@/components/AnimatedDrawSection";
import API from "../api.js";

export default {
  name: "Main",
  data: function () {
    return {
      names: [],
      showValidation: false,
      drawInProgress: false,
      drawFinished: false,
      calculating: false,
      showLoading: false,
      timeouts: [],
      drawResult: {},
      drawId: undefined,
    };
  },
  refs: { animation: AnimatedDrawSection, input: InputSection },
  components: {Card, InputSection, AnimatedDrawSection },
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
      this.$refs.animation.toggleGather()
    },
    animateDraw() {
      this.$refs.animation.pullCardsFromHat()
    },
    cancel() {
      this.drawInProgress = false;
      this.toggleGather();
      this.$refs.animation.clearAnimations();
    },
    colour(index = 0) {
      if (!(Math.floor(index / 6) % 2))
        return this.colours['--secondary-colour']
      else return this.colours['--main-colour']
    },
    calculate() {
      this.drawInProgress = true;
      this.calculating = true;
      this.toggleGather();
      const body = {"people": this.names};
      API.post("calculation", body)
          .then(response => {
            this.drawResult = response.data.result;
            this.drawId = response.data.id
            this.calculating = false;
          })
          .catch(e => {
            this.errors.push(e)
          })
    },
    updateDrawFinished() {
      this.drawFinished = true;
      this.drawInProgress = false;
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
      }
    },
    remove(index) {
      this.names.splice(index, 1)
    }
  },
  computed: {


  },
  mounted() {
    this.$watch("$refs.animation.gatherStatus", (newValue) => {
      if ((newValue == 'gathered') && !this.calculating) {
        setTimeout(() => {this.animateDraw()}, 1250)
      } else if (newValue == 'gathered') {
        this.showLoading = true;
      }
    })
    this.$watch("calculating", (newValue) => {
      if (!newValue && this.$refs.animation.gatherStatus == 'gathered') {
        this.showLoading = false
        this.animateDraw()
      }
    })
  }
};
</script>



<style lang="scss" scoped>

.main {
  width: 100%;
  position: relative;
}

</style>
