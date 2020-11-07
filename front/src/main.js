import Vue from 'vue'
import App from './App.vue'
import Replay from '@/pages/replay'
import Main from "@/pages/main";
import vuetify from './plugins/vuetify';
import VueRouter from 'vue-router'

Vue.config.productionTip = false

const routes = [
  {path: "/", component: Main},
  {path: "/replay/:id", component: Replay}
]

const router = new VueRouter({routes:routes, mode:'history'})

Vue.use(VueRouter)

new Vue({
  vuetify,
  router,
  render: h => h(App)
}).$mount('#app')
