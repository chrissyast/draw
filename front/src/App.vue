<template>
  <div id="app">
    <v-app>
      <InputSection ref="input"
                    :names="names"
                    :showValidation="showValidation"
                    v-if="!(drawInProgress || drawFinished)"
                    v-on:add="add"
                    v-on:calculate="calculate"
                    v-on:gather="toggleGather"/>
      <div class="main container">
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
    </v-app>
  </div>
</template>

<script>
import InputSection from "./components/InputSection.vue";
import Card from "./components/Card.vue";
import CardStack from "./components/CardStack.vue";
import ResultSection from "@/components/ResultSection";
import API from "./api.js";

export default {
  name: "App",
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
  components: { Card, CardStack, InputSection, ResultSection },
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
      this.drawInProgress = true;
      if (this.gatherStatus === "ungathered") {
        this.gatherStatus = "gathering";
        var animationTime =
          parseInt(this.$style.gatheringTime.split("ms")[0], 10) +
          parseInt(this.$style.putAwayTime.split("ms")[0], 10);
        this.timeouts.push(setTimeout(this.startDraw, animationTime));
      } else {
        this.gatherStatus = "ungathered";
        for (var timeout in this.timeouts) {
          clearTimeout(this.timeouts[timeout]);
        }
      }
    },
    calculate() {
        const body = {"people": this.names};
        API.post("calculation", body)
          .then(response => {
            this.drawResult = response.data.result;
            this.showResults = true
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
          console.log("draw finished");
          this.drawFinished = true;
          this.drawInProgress = false;
        }, delay * i + 1000)
      );
    },
    showSummary() {
      this.showSummary;
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
    gatherText() {
      return this.gatherStatus === "ungathered" ? "gather" : "ungather";
    },
  },
};
</script>

<style module lang="scss">
@import "./styles/variables.scss";
:export {
  maxUngathered: $maximum-ungathered-cards;
  gatheringTime: $gathering-time;
  putAwayTime: $put-away-time;
  nextCardDelay: $next-card-delay;
}
</style>

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
