<script setup lang="ts">
import { onMounted, ref, defineProps } from 'vue';
import { fetchAll } from '../utils/fetchAll';

const props = defineProps(['color'])
const users = ref('')
onMounted( async () => {

    const all_users = await fetchAll('users')
    users.value = all_users
})

</script>


<template>

<v-dialog  
       overlay-color="black"
  overlay-opacity="1"
  theme="dark"
   max-width="500"
   
   >
    <v-card height="200">
      <v-card-title>
     Profiles
      </v-card-title>
     <center>
        <div
         class="user-item" 
         v-if="users.length > 0" style="align-items: center; display: flex;">
    <div 
    class="itself"
    v-for="(user, index) in users">
    <v-avatar 
    :style="{'--color': props.color? props.color : 'red'}" 
    class="av" color="surface-variant" 
    size="80"></v-avatar>
    <p>{{ user.replace('.db', '') }}</p>
    <div style="border: 2px solid white" class="d-flex"><v-icon>mdi-pencil</v-icon><p >EDIT</p></div>
</div>
<div 
    class="itself">
    <v-avatar 
    :style="{'--color': props.color? props.color : 'red'}" 
    class="av"  
    size="80">
<v-icon>mdi-plus</v-icon>
</v-avatar>
<p>Create new profile</p>
</div>
</div>

</center>
      <center>
      <div style="height: 50vh" v-if="users.length == 0">
        <v-icon style="margin-top: 6vh"  size="x-large">mdi-alert-circle</v-icon>
        <h1>No profiles found.</h1>
     
      <p>Try fetching data from your media using the<a href="/how_to_desktop_client"> Desktop CLI </a>, or manually adding a file to the captions folder with the corresponding ID as it's name.</p>
      <v-icon @click="fetch_all_media" style="cursor: pointer; margin-top: 5vh;" size="x-large">mdi-file-search-outline</v-icon>
      <p>Try to locate it online!</p>
    </div>  </center>
    </v-card>
</v-dialog>
</template>

<style>
.user-item {
    overflow: hidden;
    width: auto;
  display: flex !important;
  align-items: center !important;
  justify-content: center;
  gap: 4vw;
}
.itself{
    cursor: pointer;
}
.av:hover{
    border: 3px solid var(--color);
}
</style>