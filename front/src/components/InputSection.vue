<template>
    <v-app>
        <div class="hello">
            <form @submit.prevent="addPerson()" style="text-align: center">
                <div class="d-flex pa-2">
                    <v-text-field outlined true width full-width false placeholder="Enter a name here" v-model="person" hide-details true style="width: 50%; display: inline-block"/>
                    <v-btn color="purple" v-on:click="calculate" :disabled="this.people.length < 3" style="display: inline-block; height:inherit">Let's buy some gifts!</v-btn>
                </div>
            </form>
            <p v-if="showValidation" class="warningMessage">
                That name already exists
            </p>
            <span v-for="(person, index) in people" :key="index" class="addedNames">
              {{person}} <img src="../assets/images/delete.png" height="10" width="10" v-on:click="removePerson(index)"/><br>
            </span>
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
              showResults: false
            }
        },
        methods: {
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
                        this.showResults = true
                    })
                    .catch(e => {
                    this.errors.push(e)
                    })
            }
        }
    }


</script>

<style scoped>

</style>