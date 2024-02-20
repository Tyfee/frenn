<script setup lang="ts">

import {onMounted, ref } from 'vue';

import { defineProps } from 'vue';
import UserDialog from './UserDialog.vue';

var is = ref('');
var icon = ref('')
const hover1 = ref(false)
const hover2 = ref(false)
const hover3 = ref(false)
const hover4 = ref(false)

onMounted(async () => {

Ignite()

  try {
    const now = new Date().getHours()
    if (now <= 12 && now >= 4){
          is.value = "Morning"
          icon.value = "mdi-weather-sunny"
    }
    if (now >= 12 && now <= 17){
          is.value = "Evening"
          icon.value = "mdi-weather-night"
    }
    if (now >= 18 && now <= 24){
          is.value = "Night"
          
          icon.value = "mdi-weather-night"
    }
    if(now >= 0 && now <= 3){
      icon.value =  "mdi-weather-night"
      is.value = "Night"
    }
  }catch{

  }
});

const props = defineProps(['click', 'cog_click', 'color', 'searchProp', 'unSearchProp', 'searchPropMobile', 'updateSearch', 'user_click']);
var s = ref('')
function Ignite(){
  return props;
}

</script>

<template>
  <div class="mx-auto hello d-flex" >
    <v-icon size="x-large">
   {{ icon }}
  </v-icon>  <h2>Good {{ is }}!</h2>

  <div class="ops d-flex ">

  <v-text-field v-model="s" @input="updateSearch(s)"  @focus="searchProp" clearable :color="color" height="50" class="searchField" label="Search Through all Media..."></v-text-field>
   
  <div class="d-flex ic_container">
    <v-icon
    @mouseover="hover1 = true"
    @mouseout="hover1 = false"
    @click="cog_click" class="search cog text-end" size="x-large"
    :style="hover1? 'color: ' + color : 'color: white'"
    >
mdi-cog
  </v-icon> 
   
  <v-icon
  @mouseover="hover2 = true"
    @mouseout="hover2 = false"
    @click="searchPropMobile"
  class="search movie text-end" size="x-large"
  :style="hover2? 'color: ' + color : 'color: white'"
  >

  mdi-movie-search
</v-icon>
<v-icon
@mouseover="hover3 = true"
    @mouseout="hover3 = false"
 
@click="click" class="search text-end" size="x-large"
:style="hover3? 'color: ' + color : 'color: white'"
>
    mdi-heart
</v-icon>
<v-icon
@click="user_click"
@mouseover="hover4 = true"
    @mouseout="hover4 = false"
    :style="hover4? 'color: ' + color : 'color: white'"

class="search account text-end"
size="x-large"
>mdi-account-circle</v-icon>
</div>
  </div>
  
 
</div>



  </template>

<style>

.ops{
  margin-left: 22vw;
  gap: 6%;
}
.movie{
  display: none !important;
}
.ic_container{
  gap: 4% !important;
  width: 20vw;
  margin-right: 20vw;
  
}
.hello {
  position: sticky !important;
  width: 100vw;
z-index: 4 !important;
top: 0;
white-space: nowrap;
}

.v-text-field input {
    font-size: 129% !important;
  }
.v-text-field{
      width: 400px;
      font-size: 3px;
}
.first{
  height: 1vw !important;
}
.search{
  cursor: pointer !important;
  font-size: 320% !important;
}


@media screen and (max-width: 500px) {
.hello{
  font-size: 20% !important;
  position: fixed !important;
  z-index: 4;
  background-color: #242424;
padding-left: 2%;
  width: 150vw;
  height: 8vh;
margin-top: 0%;
  align-items:end;
}
.search{
  
  font-size: 200% !important;
}
.v-text-field{
      width: 200px;
      font-size: 3px;
    display: none !important;
    margin-top: 12%;
}
.ops{
  margin-left: 5%;
}
.movie{
  display:contents !important;
}
}
</style>
