<template>
        <div class="hello">
            <form @submit.prevent="addPerson()">
                <div class="d-inline-flex input-section" style="min-width: 20px">
                    <v-text-field class="input" outlined placeholder="Enter a name here" v-model="person" style="min-width: 20vw; min-height:50px; height:inherit" hide-details/>
                    <v-btn class="submit-button" v-bind="props()" v-on:click="calculate" :disabled="this.$attrs.names.length < 3" style=" height:inherit">Let's buy some gifts!</v-btn>
                </div>
            </form>
            <p v-if="showValidation" class="warningMessage">
                That name already exists
            </p>
          <!--
                <v-system-bar v-bind:color="colour(index) + ' lighten-' + (index % 6)">
                </v-system-bar>

        -->
        </div>
</template>

<script>
    export default {
        name: "InputSection",
        data() {
            return {
              person: '',
              errors: [],
              result: [],
              showValidation: false,
              showResults: false,
              colours: {
                  "--main-colour":"blue",
                  "--secondary-colour":"orange"
              }
            }
        },
        computed: {


        },
        methods: {
            props() {
               let props = {}
                switch(this.$vuetify.breakpoint.name) {
                    case 'xs':
                        props['x-small'] = true
                        break
                    case 'sm':
                        props['small'] = true
                        break
                    case 'lg':
                        props['large'] = true
                        break
                    case 'xl':
                        props['x-large'] = true
                        break
                  }
                props['color'] = this.colour()
                return props
            },
            colour(index = 0) {
                // TODO implement row count from https://stackoverflow.com/a/49090306/8940624 so that you always get a new colour on wrap.
                // TODO reverse fading direct for alternate colour (i.e. go from lighter to normal)
               if (!(Math.floor(index / 6) % 2))
                return this.colours['--secondary-colour']
                else return this.colours['--main-colour']
            },
            addPerson() {
                this.$emit("add", this.person)
            },
            calculate() {
                this.$emit("calculate")
                this.$emit("gather")
            }
        }
    }


</script>

<style>

 .input-section {
     width: 66%;
     margin: auto
 }

 @media only screen and (max-width: 800px) {
  /*   TODO implement sass
       TODO try to understand https://stackoverflow.com/questions/1495407/maintain-the-aspect-ratio-of-a-div-with-css to be able to implement a max height of [80% of (vh - 150px)] but still keep width relative
     */
  .addedNames {
      height: 25vw;
      width: 25vw;
  }
 .input-section {
     width: auto;
     padding: 5px;
 }
 .input {

 }

 h1 {
     font-size: 5vw;
 }
}

</style>