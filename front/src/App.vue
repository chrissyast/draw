<template>
  <div id="app">
    <v-app>
      <InputSection ref="input" v-on:foo="bar" v-on:calculate="calculate"/>
      <div class="main container">
        <transition name="fade" mode="out-in">
          <div v-if="!drawFinished" key="foo">
            <div class="container" v-if="!drawFinished">
              <v-btn @click="toggleGather">{{ gatherText }}</v-btn>
            </div>
            <div
              v-if="!drawFinished"
              class="cardStack container"
              style="height: 80vh; position: relative"
            >
              <CardStack
                :gatherStatus="gatherStatus"
                :names="names"
                ref="stack"
              />
            </div>
          </div>
          <div v-if="drawFinished" key="bar">{{ drawResult }}</div>
        </transition>
      </div>
    </v-app>
  </div>
</template>

<script>
import InputSection from "./components/InputSection.vue";
import Card from "./components/Card.vue";
import CardStack from "./components/CardStack.vue";
import API from "./api.js";

export default {
  name: "App",
  data: function () {
    return {
      names: [],
      gatherStatus: "ungathered",
      showValidation: false,
      drawFinished: false,
      displaySummary: false,
      timeouts: [],
      drawResult: {},
    };
  },
  refs: { stack: CardStack, input: InputSection },
  components: { Card, CardStack, InputSection },
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
        const body = {"people": this.$refs.input.people};
        API.post("calculation", body)
          .then(response => {
            console.log(response)
            debugger;
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
        }, delay * i + 1000)
      );
    },
    showSummary() {
      this.showSummary;
    },
    bar(event) {
      this.showValidation = false;
      if (event !== '' && !this.names.includes(event.toString())){
            this.names.push(event.toString());
            // TODO make this into a prop
            this.$refs.input.person = '';
            this.$refs.input.people.push(event.toString())
            this.showResults = false;
      }
      if (this.names.includes(event.toString())){
        this.showValidation = true;
      }
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
