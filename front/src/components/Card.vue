
<template>
    <v-card class="card ma"
            :class="cardClass"
            :style="cardStyle"
            shaped
            elevation="8"
    >
        <v-system-bar v-bind:color="colour(this.$attrs.index)">
            <img v-if="this.gatherStatus=='ungathered'" src="../assets/images/delete.png" style="background-color: transparent;  filter:  invert(100%);
            -webkit-filter: invert(100%);" height="10" width="10" v-on:click="removePerson()" align="right"/>
        </v-system-bar>
        <h3 class="cardTitle">{{ name }}</h3>
    </v-card>
</template>

<script>
export default {
  name: "Card",
  data: function () {
    return {
      selected: false,
      assignedColours: []
    };
  },
  props: {
    name: "",
    gatherStatus: String,
  },
  methods: {
    removePerson() {
      this.$emit("remove", this.$attrs.index)
    },
    colour(index = 0) {
        if (!this.assignedColours[index]) {
            this.assignedColours[index] = this.colours[Math.floor(Math.random() * this.colours.length)]
        }
        return this.assignedColours[index]
    }
  },
  computed: {
    cardClass() {
      return this.selected ? "selected" : this.gatherStatus;
    },
    cardStyle() {
      return this.selected ? `z-index: ${this.selectedOrder};` : "";
    },
    colours() {
        let colours = this.$style.colours.substring(1,this.$style.colours.length-1)
        colours = colours.split(", ")
        return colours
    }
  },
};
</script>

        <!-- Add "scoped" attribute to limit CSS to this component only -->


<style module lang="scss">
@import "../styles/colours.scss";
:export {
  colours:$cool-colours;
}
</style>

<style lang="scss">
@import "../styles/variables.scss";
$cardHeight: 100px;


.card {
  width: 25%;
  left: 37.5%;  // needs to be (50% - half of width)
  border-style: solid;
  height: $cardHeight;
  background-color: red;
  transition: transform $gathering-time, opacity $gathering-time,
    top $gathering-time !important;
  position: absolute !important;



  &.gathered {
    transform: scale(0.2);
    top: 50%;
  }

  &.selected {
    visibility: visible;
    top: -25%;
  }
}
@for $i from 1 through $maximum-ungathered-cards {
  .card:not(.gathered):not(.selected):nth-child(#{$i}) {
    $index: $i - 1;
    $row: floor($index / 3);
    z-index: $maximum-ungathered-cards - $i;
    transform:  translateY($cardHeight * $row) translateX(100% * (($index % 3) - 1));


    &.gathering {
      transform: scale(1 - ($i/10)) translateY(((50px * $i)));
      @if ($i) > $maximum-gathered-cards {
        opacity: 0;
      }
    }
  }
}
</style>
