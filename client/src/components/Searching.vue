<script setup lang="ts">
import {onMounted, ref, defineProps} from 'vue'
import { fetchAll } from '../utils/fetchAll';

const allItems = ref(null)
const isHoveredArray = ref([] as boolean[])

onMounted(async () => {
allItems.value = await fetchAll('all')

  isHoveredArray.value = Array(props.searching.length).fill(false);

})
const handleMouseOver = (index: number) => {
  isHoveredArray.value[index] = true;
};

const handleMouseOut = (index: number) => {
  isHoveredArray.value[index] = false;
};
const props = defineProps(['showTitle','backAction', 'searching', 'color', 'colorProp', 'clickProp'])

    </script>

<template>
    <div  class="d-flex headerr">
    <v-icon :style="{ '--color': $props.color }" @click="backAction" size="x-large" class="backArrow">mdi-arrow-left</v-icon>
    <h1 class="text-start damn">Your search results...</h1></div> 
    <div class="main2">
      
        <center>
        <v-row class="mb-5">
        <v-card
          v-for="(media, index) in $props.searching"
          :key="index"
          class="mx-2 flex-shrink-0 s"
          width="180"  
          min-width="180"  
           height="260"
          :image="'/covers/' + media.id + '.jpg'"
          @mouseover="handleMouseOver(index)"
          @mouseout="handleMouseOut(index)"
         :style="isHoveredArray[index] ? 'border: 4px solid ' + color : 'border: 0px solid white'"
         @click="clickProp(media)"
          theme="dark"
          >
          
<div v-if="showTitle" :style="{justifyContent: 'center', alignItems: 'center', color: $props.color, width: gotArr ? getLastPosition(media.id) + '%' : '100%' }" class="text"><h1 style="font-size: 20px !important;">{{ media.title }}</h1></div>

      </v-card>
     
      </v-row>
    </center>
    
</div>
</template>

<style>
.main2{

    height: 90vh;
}
.text{
  background-color: #23232377;
  
}
.s{
    margin-top: 3%;
    cursor: pointer;
    user-select: none;
}
.mb5{
margin-bottom: 5% !important;
}
.headerr{
    display: none !important;
}
.backArrow {
    font-size: 50px !important;
    cursor: pointer;
    color: rgba(255, 255, 255, 0.724);
    transition: all 0.3s ease-in-out;
}
.backArrow:hover{
   color: var(--color);
}
.damn{ 
    margin-left: 2%;
}
h1{
    font-size: 40px !important;
}
@media screen and (max-width: 500px) {
    .main2{
    height: 90vh;
    width: 95vw;
    margin-left: 1vw;
    margin-top: 35%;
    overflow: scroll;
}
.mb5{
margin-bottom: 9% !important;
}
.damn{
   display: none;
}
.backArrow{
    display: none !important;
}
.s{
    width: 2vw !important;
    margin-top: 10%;
}

}
</style>