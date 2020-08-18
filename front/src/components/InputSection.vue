<template>
    <v-app>
        <div class="hello">
            <form @submit.prevent="addPerson()">
                <div class="d-inline-flex input-section" style="min-width: 20px">
                    <v-text-field class="input" outlined placeholder="Enter a name here" v-model="person" style="min-width: 20vw; min-height:50px; height:inherit" hide-details/>
                    <v-btn class="submit-button" v-bind="props()" v-on:click="calculate" :disabled="this.people.length < 3" style=" height:inherit">Let's buy some gifts!</v-btn>
                </div>
            </form>
            <p v-if="showValidation" class="warningMessage">
                That name already exists
            </p>
    <!--        TODO this should probably be its own component-->
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
            <br>
                <span v-if="showResults" v-for="(buyer, index) in result" :key="index">
                    <b>{{buyer}}</b> will buy for <b>{{result[buyer]}}</b><br>
                </span>
        </div>
    </v-app>
</template>

<script>
import API from '../api'
    export default {
        name: "InputSection",
        data() {
            return {
              person: '',
              people: [],
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
                this.showValidation = false;
                if (this.person !== '' && !this.people.includes(this.person.toString())){
                    this.people.push(this.person.toString());
                    this.person = '';
                    this.showResults = false;
                }
                if (this.people.includes(this.person.toString())){
                    this.showValidation = true;
                }
            },
            removePerson(index) {
                this.showResults = false
                this.people.splice(index, 1)
            },
            calculate() {
                const body = {"people": this.people};
                API.post("calculation", body)
                    .then(response => {
                        this.result = response.data.result;
                        this.$emit('submit', this.result)
                        this.showResults = true
                    })
                    .catch(e => {
                    this.errors.push(e)
                    })
            }
        }
    }


</script>

<style>

/*
  :root {
    --main-colour: blue;
    --secondary-colour: orange
  }
*/

 .addedNames {
     height: 200px;
     width: 200px;
 }
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
/*
    body {
        background-image: url('https://i.ytimg.com/vi/QmZMMTHFIYY/maxresdefault.jpg');
    }
    */
</style>