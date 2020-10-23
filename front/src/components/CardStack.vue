<template>
    <div class="animationSpace" :class="gatherStatus">
        <div class="cards" :class="gatherStatus">
            <card
                    v-for="(name, index) in names"
                    v-on:remove="remove"
                    :key="name"
                    :index="index"
                    :gatherStatus="gatherStatus"
                    :name="name"
                    ref="cards"
            />
        </div>
        <div class="hat" v-if="this.gatherStatus !== 'ungathered'">
            <div class="container">
                <img class="hat-part back" src="../assets/whole hat.png" />
                <img class="hat-part front" src="../assets/hatfront.png" />
            </div>
        </div>
    </div>
</template>


<script>
import Card from "./Card.vue";

export default {
  name: "CardStack",
  props: {
    names: Array,
    gatherStatus: String,
  },

  components: { Card },
  methods: {
    selectCard(buyer, recipient, index) {
      console.log(`${buyer} will buy for ${recipient}`);
      var recipientIndex = this.names.indexOf(recipient);
      var card = this.$refs.cards[recipientIndex];
      card.selected = true;
      card.selectedOrder = index;
    },
    remove(index) {
        this.$emit("remove", index)
    }
  },
};
</script>

<style module lang="scss">
@import "../styles/variables.scss";
:export {
  maxUngathered: $maximum-ungathered-cards;
  gatheringTime: $gathering-time;
  putAwayTime: $put-away-time;
}
</style>

<style lang="scss">
@import "../styles/variables.scss";

.animationSpace {
  width: 100%;
  height: 100%;
  bottom: 0px;
  &.gathered {
    overflow: hidden;
    bottom: 0px;
    top: 0px;
  }
}

.hat {
  position: absolute;
  height: 70%;
  width: 100%;
  left: 3%;
  top: 36%;
}

.hat-part {
  position: absolute;
  height: 100%;
  width: 100%;
  left: 0pc;
  top: 0pc;
  object-fit: contain;

  &.front {
    z-index: 2;
  }
  &.back {
    z-index: 0;
  }
}

.cards {
  position: relative;
  height: 70%;
  width: 100%;
  margin: auto;
  top: 5%;
  &.gathering {
    animation: putAway $put-away-time ease-in-out forwards 1;
    animation-delay: $gathering-time;
    z-index: 3; // keeps cards in front of hat while gathering
    //visibility: hidden;
  }
  &.gathered {
    top: 40%;
    visibility: hidden;
    z-index: 1; // TODO change to 1 (99 for dev)
    //opacity: 0.2;
  }
}

@keyframes putAway {
  0% {
    visibility: visible;
    z-index: 1;
    top: 5%;
  }
  50% {
    transform: scale(0.25);
    top: 5%;
    z-index: 1;
  }
  100% {
    transform: scale(0.2);
    top: 40%;
    z-index: 1;
  }
}
</style>
