<script setup lang="ts">
import { defineProps, onMounted, ref } from 'vue'
onMounted( async () => {
    Ignite()
})
const props = defineProps(['searchProp', 'color', 'mobileSearching', 'updateSearch'])
const s = ref('')

function Ignite(){
    return props;
}
</script>

<template>
<div class="msContainer">
  <v-text-field v-model="s" @input="updateSearch(s)" v-if="mobileSearching"  @focus="searchProp" clearable :color="color" height="50" class="searchFieldMobile" label="Search Through all Media..."></v-text-field>
   </div>    
</template>

<style scoped>


.searchFieldMobile{
display: none !important;
width: 90vw;
margin-left: 4%;
z-index: 4;
}
.msContainer{
height: 10vh;
margin-top: 4%;
position: fixed !important;
z-index: 4;
}
@media screen and (max-width: 500px) {
  .searchFieldMobile{
    display: block !important;
  }  
 }

</style>