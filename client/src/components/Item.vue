<script setup lang="ts">
import { defineProps, ref, onMounted } from 'vue';
import { fetchAll } from '../utils/fetchAll';

const props = defineProps(['showTitle', 'width', 'height', 'fontSize','currentlyFetching', 'clickProp', 'colorProp', 'showDuration', 'sectionName', 'showFavorite'])
const isHoveredArray = ref([] as boolean[]);
const arr = ref([])
const gotArr = ref(false)

onMounted(async() => {
  isHoveredArray.value = Array(props.currentlyFetching.length).fill(false);

arr.value = await fetchAll('current_watching')
gotArr.value = true
});


const getLastPosition = (id: any) => {
  const item = arr.value.find((obj: any) => obj.id === id);

  console.log("Cause if the business is trueeeeeeeeee?" + item)
  return item ? item.last_position : null;
};

const handleMouseOver = (index: number) => {
  isHoveredArray.value[index] = true;
};

const handleMouseOut = (index: number) => {
  isHoveredArray.value[index] = false;
};

</script>

<template>
    
   <h2 :style="{fontSize: props.fontSize + 'px'}" class="text-start ">{{ sectionName }}</h2> 
<div :style="'--scrollbar-thumb-color: ' + colorProp" class="flex-row">
<v-card
          v-for="(media, index) in currentlyFetching"
          :key="index"
          @mouseover="handleMouseOver(index)"
          @mouseout="handleMouseOut(index)"
         :style="isHoveredArray[index] ? 'border: 4px solid ' + colorProp : 'border: 0px solid white'"
         class="mx-2 flex-shrink-0"
          :width="props.width? props.width : 220"  
        
           :height="props.height ? props.height : 300"
          :image="'/covers/' + media.id + '.jpg'"
          
          theme="dark"
          @click="clickProp(media)"

        >
        <div v-if="showTitle == true" :style="{justifyContent: 'center', alignItems: 'center', color: colorProp, width: gotArr ? getLastPosition(media.id) + '%' : '100%' }" class="text"><h1 style="font-size: 20px !important;">{{ media.title }}</h1></div>

        <div v-if="showDuration == true" :style="{ backgroundColor: colorProp, width: gotArr ? getLastPosition(media.id) + '%' : '100%' }" class="duration"></div>
   <v-icon v-if="showFavorite == true" :style="{color: props.colorProp}" size="x-large" class="favorited">mdi-heart</v-icon>
      </v-card>
</div>
</template>

<style scoped>
div {
    user-select: none;
}
.text{
  background-color: #23232377;
  
}
.favorited{
  position: absolute;
  bottom: 0;
  right: 0;
}
.mx-2 {
    cursor: pointer !important;
    user-select: none;
  }

  .mx-2-hovered {
    border: 4px solid gold;
    box-shadow: inset 500px 500px rgba(255, 255, 255, 0.207);
  }
   .flex-row {
    display: flex;
    width: 100%; 
    margin-top: 1%;
    overflow-x: auto; 
  }
  .d-flex {
    gap: 2% !important;
  }

  .duration {
  height: 6px;
  position: absolute;
  z-index: 2;
}
.flex-row::-webkit-scrollbar {
    width: 2px; 
  }

  .flex-row::-webkit-scrollbar-thumb {
    background-color: var(--scrollbar-thumb-color, gold);
    border-radius: 2px !important;
    height: 2px !important;
 border-bottom: 4px solid #242424;
 box-shadow: inset 500px 500px rgba(0, 0, 0, 0.442);
  }


  .flex-row::-webkit-scrollbar-track {
    height: 3px !important;
    background-color: transparent; /* Transparent background for the track */
  }

  @media screen and (max-width: 500px) {
    .v-card {
    cursor: pointer !important;
    user-select: none;
}
.sec{
  margin-top: 10%;
 
}
.flex-row {
    display: flex;
    width: auto !important; 
    
    margin-top: 1%;
    overflow-x: auto; 
  }
  }
</style>