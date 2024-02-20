<script setup lang="ts">
import { onMounted, ref, defineProps } from 'vue';
import { fetchAll } from '../utils/fetchAll';

const props = defineProps(['id'])
const captions = ref('')
onMounted( async () => {

    const all_captions = await fetchAll('all_captions')
    captions.value = all_captions

    return props
})

</script>


<template>

<v-dialog  
       overlay-color="black"
  overlay-opacity="1"
  theme="dark"
   max-width="600">
    <v-card>
      <v-card-title>
      Subtitles / CC (.vtt files only)
      </v-card-title>
      <v-list v-if="captions.length > 0">
      <v-list-item
      
        v-for="(item, index) in captions" 
        :key="index"
        :value="item"
        color="primary"
      >
      {{ item }}
      </v-list-item>
      </v-list>
      <center>
      <div style="height: 50vh" v-if="captions.length == 0">
        <v-icon style="margin-top: 6vh"  size="x-large">mdi-alert-circle</v-icon>
        <h1>No corresponding .vtt files found on the captions folder.</h1>
     
      <p>Try fetching data from your media using the<a href="/how_to_desktop_client"> Desktop CLI </a>, or manually adding a file to the captions folder with the corresponding ID as it's name.</p>
      <v-icon @click="fetch_all_media" style="cursor: pointer; margin-top: 5vh;" size="x-large">mdi-file-search-outline</v-icon>
      <p>Try to locate it online!</p>
    </div>  </center>
    </v-card>
</v-dialog>
</template>

<style>

</style>