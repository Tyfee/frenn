import { createApp } from 'vue'
import App from './App.vue'
import '@mdi/font/css/materialdesignicons.min.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import '@cloudgeek/vue3-video-player/dist/vue3-video-player.css'

import './style.css'

// Create the Vuetify instance
const vuetify = createVuetify({
  components,
  directives,
})

// Create the Vue app instance and use Vuetify
const app = createApp(App, {
  strict: false
})

app.use(vuetify).mount('#app')