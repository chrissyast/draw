<template>
        <div class="hello">
            <form @submit.prevent="addPerson()">
                <div class="d-inline-flex input-section" style="min-width: 20px">
                    <v-text-field class="input" outlined :placeholder="placeholderText" v-model="person" style="min-width: 20vw; min-height:50px; height:inherit" hide-details/>
                    <v-btn class="submit-button"
                           v-bind="props()"
                           v-on:click="buttonClick"
                           :disabled="this.names.length < 3"
                           style=" height:inherit">{{ buttonText }}
                    </v-btn>
                </div>
            </form>
          <div style="min-height: 25px">
            <p class="warningMessage" v-show="showValidation">
              That name already exists
            </p>
          </div>
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
              colours: {
                  "--main-colour":"blue",
                  "--secondary-colour":"orange"
              }
            }
        },
        props: {
          showValidation: Boolean,
          names: {}
        },
        computed: {
          buttonText() {
            return "Let's buy some gifts!"
          },
          placeholderText() {
            switch (this.names.length) {
              case 0:
                return "Enter the first name to start"
              case 1:
                return "Good job! Now enter another"
              case 2:
                return "One more and we can get started..."
              case 3:
                return "Nice one! Either start the draw or keep adding people"
              case 4:
                return "Wow, you do have a lot of friends! You don't need me any more..."
            }
              return ""
          }

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
            colour() {
                return this.colours['--secondary-colour'] // TODO something more interesting with the colour?
            },
            addPerson() {
                this.$emit("add", this.person)
            },
            buttonClick() {
              if (this.drawInProgress) {
                this.cancel()
              } else {
                this.calculate()
              }
            },
            calculate() {
                this.$emit("calculate")
            },
            cancel() {
              this.$emit("cancel")
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

       /*TODO try to understand https://stackoverflow.com/questions/1495407/maintain-the-aspect-ratio-of-a-div-with-css to be able to implement a max height of [80% of (vh - 150px)] but still keep width relative*/


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