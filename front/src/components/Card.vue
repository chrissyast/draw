
<template>
    <v-card class="card ma"
            :class="cardClass"
            :style="cardStyle"
            shaped
            elevation="8"
    >
        <v-system-bar>
            <img src="../assets/images/delete.png" style="background-color: transparent;  filter:  invert(100%);
            -webkit-filter: invert(100%);" height="10" width="10" v-on:click="removePerson()" align="right"/>
        </v-system-bar>
        <h3 class="cardTitle">{{ name }}</h3>
    </v-card>
</template>

        <!--
        <template>
            <v-card class="card ma-2"
                    :class="cardClass"
                    :style="cardStyle"
                    shaped
                    elevation="8">
                 TODO implement color
         <v-system-bar v-bind:color="colour(index) + ' lighten-' + (index % 6)">
        <v-system-bar>
            <img src="../assets/images/delete.png" style="background-color: transparent;  filter:  invert(100%);
      -webkit-filter: invert(100%);" height="10" width="10" v-on:click="removePerson(index)" align="right"/>
        </v-system-bar>
        <h1 style="padding: 0px 8px">{{name}}</h1>
        <br>
    </v-card>
</template>
        -->
<!--
            <div class="d-flex justify-center flex-wrap ma-2 pa-2">
                <v-card v-for="(person, index) in people"
                        :key="index"
                        class="addedNames ma-2"
                        shaped
                        elevation="8"
                >
                <v-system-bar v-bind:color="colour(index) + ' lighten-' + (index % 6)">
                    <img src="../assets/images/delete.png" style="background-color: transparent;  filter:  invert(100%);
      -webkit-filter: invert(100%);" height="10" width="10" v-on:click="removePerson(index)" align="right"/>
                </v-system-bar>
                    <h1 style="padding: 0px 8px">{{person}}</h1>
                    <br>
                </v-card>
            </div>
-->

<script>
export default {
  name: "Card",
  data: function () {
    return {
      selected: false,
    };
  },
  props: {
    name: "",
    gatherStatus: String,
    selectedOrder: Number,
  },
  methods: {
    removePerson() {
        this.$emit("remove", this.$attrs.index)
    }
  },
  computed: {
    cardClass() {
      return this.gatherStatus + (this.selected ? " selected" : "");
    },
    cardStyle() {
      return this.selected ? `z-index: ${this.selectedOrder};` : "";
    },
  },
};
</script>

        <!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss">
@import "../styles/variables.scss";
$cardHeight: 100px;


.card {
  width: 50%;
  left: 25%;
  border-style: solid;
  height: $cardHeight;
  border-radius: 100px;
  background-color: red;
  transition: transform $gathering-time, opacity $gathering-time,
    top $gathering-time !important;
  position: absolute !important;



  &.gathered {
    transform: scale(0.2);
    top: 50%;
    //visibility: visible;
    //transition: none;
  }

  &.selected {
    visibility: visible;
    transform: scale(0.6);
    top: -25%;
  }
}
@for $i from 1 through $maximum-ungathered-cards {
  .card:not(.gathered):nth-child(#{$i}) {
    $index: $i - 1;
    z-index: $maximum-ungathered-cards - $i;
    transform: translateY($cardHeight * $index);

    &.gathering {
      transform: scale(1 - ($i/10)) translateY(((50px * $i)));
      @if ($i) > $maximum-gathered-cards {
        opacity: 0;
      }
    }
  }
}
</style>
