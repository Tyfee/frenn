<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import HelloWorld from './components/HelloWorld.vue'
import Item from './components/Item.vue'
import Searching from './components/Searching.vue'
import FloatingSearch from './components/FloatingSearch.vue'
import VideoControls from './components/VideoControls.vue';
import UserDialog from './components/UserDialog.vue';
import configs from './components/config.json'
import 'vuetify/dist/vuetify.css'


import addFav from './utils/addFav'
import removeFav from './utils/removeFav'
import updateLast from './utils/updateLast'
import filterSearch from './utils/filterSearch';
import { fetchAll } from './utils/fetchAll';

const fetchedMedia = ref([]);
const allSeries = ref([]);
const sorting = ref('Last Added')
const allMovies = ref([]);
const allBooks = ref([]);
const currently_watching = ref([])
const searching = ref(false);
const externalServerPopup = ref(false)
const checkedValues = ref(['All Your Media'])

const font_size = ref(30)

const cover_width = ref(220)

const cover_height = ref(330)

const show_title = ref(false)

const currentProgress = ref(0)
const duration = ref(0)
const current_settings = ref(0)

const dialog = ref(false);
const favorites = ref(false);
const settings = ref(false);

const profiles = ref(false);

const theme_color = ref('#FFD700')
const favs = ref([])
const watching = ref(false)
const selectedMedia = ref([]);
const episode = ref(1)
const season = ref(1)
const episodes = ref(null)
const episodes_count = ref(1)
const downloading = ref(false)
const searchValue = ref('')


//video control refs

const is_playing = ref(false)


const control_boolean = ref(false)
  
const Idk = () => {
 const vid = document.getElementById('video')?.currentTime
 const totalDuration = document.getElementById('video')?.duration
 currentProgress.value = vid
 if(currentProgress.value){
  console.log(selectedMedia.value.id, currentProgress.value)

 
  updateLast(selectedMedia.value.id, Math.floor((100 * Math.floor(currentProgress.value) / totalDuration)))

}}

const updateTime = () => {
  
 const vid = document.getElementById('video')?.currentTime
 const totalDuration = document.getElementById('video')?.duration
 currentProgress.value = vid
duration.value = totalDuration
 


}


const handleDownload = () => {
  downloading.value = true;
  window.location.href = host + ':' + port + '/download/file/' + selectedMedia.value.id
  
  setTimeout(() => {

    downloading.value = false;
  }, 4000)

}

const playMedia = () => {
  watching.value = true;
}
const closeMedia = () => {
const vid  = document.getElementById('video') as HTMLMediaElement || null
  

  watching.value = false;
  is_playing.value = false;
if(vid){  
  updateLast(selectedMedia.value.id, Math.floor((100 * Math.floor(currentProgress.value) / vid.duration)))
}else{
  console.log('vid is null')
}
}

const handleChangePosition= (nav_value: any) => {
      // Your logic here using the nav_value parameter
      console.log('Changing position with nav_value:', nav_value);
    }
const host = configs.url;
const port = configs.port;

const source = `<source :src="${host}:${port}/file/${selectedMedia.id}" type="video/mp4">`



const fetch_current = async () => {
  const res = await fetch(`${host}:${port}/current_watching`);
   if(!res.ok){
    throw new Error("try again mate!" + res.status)
   }
  const wdata = await res.json()
  console.log(wdata)
  currently_watching.value = wdata
}


const fetch_all_media = async () => {

  fetch_current()
  
  const resp = await fetchAll('all');
  if(sorting.value == 'Last Added'){
    fetchedMedia.value = resp;
    allSeries.value = resp.filter((i: any) => i['id'].includes('S'));
    allMovies.value = resp.filter((i: any) => i['id'].includes('M'));
  
  }
  
  if(sorting.value == 'A-Z'){
   const atoz = [...resp].sort(function (a, b) {
    
  if (a.title < b.title) {
    const atoz = [...resp].sort((a, b) => a.title.localeCompare(b.title));
      fetchedMedia.value = atoz;
      allSeries.value = atoz.filter((i: any) => i['id'].includes('S'));
    allMovies.value = atoz.filter((i: any) => i['id'].includes('M'));
   
  }
   
  })
} 
  searchValue.value = resp;
   
}
onMounted(async () => {

if(document){
  document.onkeydown = (e) => {
     switch(e.key){
      case "ArrowRight":
           handleAdvance()
      break;
      case "ArrowLeft":
         handleReturn()
         break;
     }
  }
}
  try {
   
fetch_all_media()

    const response = await fetch(`${host}:${port}/favorites`);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const fdata = await response.json()
    console.log(fdata);
    favs.value = fdata



  } catch (error) {
    console.error('Error fetching data:', error);
  }


});

const openFavorites = async () => {
  favorites.value = true
console.log(filteredMedia.value)

 }
const openSearch = async () => {
   searching.value = true
}
const openSearchMobile = async () => {
   searching.value = !searching.value
}
const closeSearch = async () => {
   searching.value = false
}



 const filteredMedia = computed(() => {
      return favs.value.map((fav) => {
        const matchingItem = fetchedMedia.value.find((item) => item.id === fav.id);
        return matchingItem || {};
      });
    })


const openDialog = async (media: any) => {
  try {
    selectedMedia.value = media;
    dialog.value = true;
    console.log(episodes_count.value)

    const response = await fetch(`${host}:${port}/watch/${media.id}`);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const data = await response.json();
    console.log(data);

    if(media.seasons >= 1){
      const response = await fetch(`${host}:${port}/season/${media.id}/${season.value}`);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    const data2 = await response.json();
    console.log(data2);
    episodes.value = data2
    episodes_count.value = data2.length
    }



  } catch (error) {
    console.error('Error fetching additional data:', error);
  }
};

  const closeDialog = () => { 
Idk()
    
  if (selectedMedia.value) {
    selectedMedia.value = null;
    dialog.value = false;
    watching.value = false;
    episodes.value = null
    downloading.value = false;
  }

};


const openSettings = () => {
 settings.value = true;
}

const TryToFilter = async (search: any) => {
 const results = await filterSearch(search)
  searchValue.value = results
  console.log(`you're searching for ${search}`)
}

const togglePlay = () => {
  const vid = document.getElementById('video') as HTMLVideoElement
  if (is_playing.value) {
        console.log('paused');
        
      is_playing.value = !is_playing.value;
        vid?.pause();
      } else {
        console.log('playing');
        
      is_playing.value = !is_playing.value;
        vid?.play();
      }

}

const handleAdd = (func: any) => {
  addFav(func);

const newItem = fetchedMedia.value.find((item) => item.id === func);

if (newItem) {
  favs.value.push(newItem);
}
}


const handleRemove = (func: any) => {
  removeFav(func)

  const newArr = favs.value.filter((i) => i.id != func)
  favs.value = newArr;
}

const toggleFullscreen = () => {
  
  const vid = document.getElementById('video') as HTMLVideoElement
  const controller = document.getElementById('video-container')
  controller?.requestFullscreen();
}

const openProfile = () => {
  profiles.value = true;
} 


const jumpTo = (pos: any) => {

  const vid = document.getElementById('video') as HTMLMediaElement;
  if(vid){
    vid.currentTime = pos;
  }
}


const handleAdvance = () => {
  console.log('cool')
  const vid = document.getElementById('video') as HTMLMediaElement;
  if(vid){
    vid.currentTime = vid.currentTime + 5;
  }
}
const handleReturn = () => {
  console.log('cool')
  const vid = document.getElementById('video') as HTMLMediaElement;
  if(vid){
    vid.currentTime = vid.currentTime - 5;
  }
}

const handleVolume = () => {
  console.log('huhh')
}

</script>
<template>
  
  <div class="main">
   <HelloWorld :handle-change-position="jumpTo" :user_click="openProfile" :update-search="TryToFilter" :un-search-prop="closeSearch" :search-prop="openSearch" :search-prop-mobile="openSearchMobile"  :color="theme_color" :cog_click="openSettings" :click="openFavorites"/>
  <FloatingSearch :update-search="TryToFilter" :mobile-searching="searching" :color="theme_color"/>


  <user-dialog
        v-model="profiles"
        v-if="profiles"
        :color="theme_color"
        />

   <div v-if="searching">
<Searching :show-title="show_title"  :click-prop="openDialog"  :color="theme_color" :back-action="closeSearch" :searching="searchValue"/>
    </div>
   <div class="main" v-if="!searching">
      
    <div style="height: 80vh;" v-if="fetchedMedia.length == 0">
        <v-icon style="margin-top: 20vh;" size="x-large">mdi-alert-circle</v-icon>
        <h1>Couldn't fetch media from {{ host }}:{{ port }}</h1>
     
      <p>Check if your server is up and running or if any settings are stopping your connection</p>
      <v-icon class="reload" @click="fetch_all_media" :style="{'cursor': 'pointer', 'margin-top': '20vh', '--color': theme_color}" size="x-large">mdi-refresh</v-icon>
      <p>Try again!</p>
     
    </div>  
 
      <Item
      v-if="fetchedMedia.length > 0"
      v-for="(section, index) in checkedValues"
      :key="index"
      :section-name="section"
      :click-prop="openDialog" 
      :color-prop="theme_color"
      :font-size="font_size"
      :width="cover_width"
      :height="cover_height"
   
      :currently-fetching="section == 'All Your Media' ? fetchedMedia :
       section === 'Keep Watching' ? currently_watching :
      section === 'Series' ? allSeries :
        section === 'Movies' ? allMovies :
        section == 'Favorites' ? favs : null"
   :show-title="show_title"
        :show-duration="section == 'Keep Watching' ? true : false"
        :show-favorite="section == 'Favorites' ? true : false"
   
        />

      <div style="height: 80vh;" v-if="checkedValues.length == 0">
        <v-icon style="margin-top: 20vh;" size="x-large">mdi-alert-circle</v-icon>
      <h1 >No Sections to Display</h1>
      <p>You can add homescreen sections on the Settings screen.</p>
   </div>  
  
  </div>


      <v-dialog  
     max-height="350"
       overlay-color="black"
  overlay-opacity="1"
  theme="dark"
  class="mainDialog"
  style="height: 10px"
  v-if="dialog"
   v-model="dialog" 
   max-width="600">
    <v-card  :style="{height: '56vh !important', border: `4px solid ${theme_color}`}">
      <v-icon :style="{'--color': theme_color}" @click="playMedia" class="play" size="x-large">
        mdi-play
      </v-icon>
      <v-img
  :width="900"
  cover  
  :height="150"
  
  aspect-ratio="1/1"
  :src="'/covers/' + selectedMedia.id + '.jpg'"
></v-img>
<div @keydown="handleAdvance" @mouseout="control_boolean = false" @mouseover="control_boolean = true" v-if="watching" id="video-container">
 
  <VideoControls
   v-show="control_boolean && watching" 
   :color="theme_color"
    :title="selectedMedia? 
    selectedMedia.title : 'loading...'" 
    :file="selectedMedia.file"
    :id="selectedMedia.id"
    :play-action="togglePlay"
    :fullscreen-action="toggleFullscreen"
    :close-action="closeMedia"
    :playing="is_playing"
    @click="console.log(currentProgress)"
    :current-position="100 * Math.floor(currentProgress) / duration"
:current-position-raw="currentProgress"
:duration="duration"    
@change-position="handleChangePosition"
@advance="handleAdvance"
@set-volume="handleVolume"
/>



<video @timeupdate="updateTime"  id="video" v-if="watching && selectedMedia.seasons == 0" width="auto" height="auto" crossorigin="anonymous">
      <source v-if="watching && selectedMedia.seasons == 0" :src="host + ':' + port + '/file/' + selectedMedia.id" type="video/mp4">
      <track
    label="Closed Captions"
    kind="subtitles"
    srclang="en"
    :src="host + ':' + port + '/captions/' + selectedMedia.id"
    default />  
      
      Your browser does not support the video tag.
    </video>

    <video id="video_season" v-if="watching && selectedMedia.seasons > 0" autoplay width="auto" height="auto" controls>
    <source v-if="watching && selectedMedia.seasons > 0" :src="host + ':' + port + '/episode/' + selectedMedia.id  + '/' + season.toString() + '/' + episode.toString()" type="video/mp4">
     </video>

  </div>

 
      <v-card-title>
        {{ selectedMedia ? selectedMedia.title : '' }}
      </v-card-title>
      <div class="d-flex picks">
      
      <v-combobox class="season_pick" v-if="selectedMedia.seasons >= 1"
  label="Season"
  :items="Array.from({ length: selectedMedia.seasons }, (_, index) => index + 1)"
  variant="outlined"
  v-model="Array.from({ length: selectedMedia.seasons }, (_, index) => index + 1)[0]"
></v-combobox>

<v-combobox class="episode_pick" v-if="selectedMedia.seasons >= 1"
  label="Episode"
     variant="outlined"
     :items="Array.from({ length: episodes_count }, (_, index) =>(index + 1).toString())"
     v-model="episode"
></v-combobox>
</div>
      <v-card-text style="max-height: 200px"
       class="overflow-y-auto">
        {{selectedMedia.desc }}
      </v-card-text>

     
      <v-card-actions v-if="!watching" class="actionBtns">
        <v-btn class="actionBtn" style="background-color: red" color="white" @click="closeDialog">
          <v-icon>mdi-close</v-icon>Close
        </v-btn>
        <v-btn class="actionBtn"  @click="!JSON.stringify(favs).includes(selectedMedia.id) ? handleAdd(selectedMedia.id) : handleRemove(selectedMedia.id)" style="background-color: rgb(238, 255, 0)" color="black">
          <v-icon v-if="!JSON.stringify(favs).includes(selectedMedia.id)">mdi-plus</v-icon><strong v-if="!JSON.stringify(favs).includes(selectedMedia.id)">Add to Favorites</strong>
          <v-icon v-if="JSON.stringify(favs).includes(selectedMedia.id)">mdi-check</v-icon><strong v-if="JSON.stringify(favs).includes(selectedMedia.id)">Favorited</strong>
      
        </v-btn>
        <v-btn class="actionBtn" @click="handleDownload" style="background-color: rgb(0, 42, 255)" color="white">
          <v-icon>mdi-download</v-icon>Download
        </v-btn>
    
      </v-card-actions>

      <v-alert
      v-if="downloading"
    type="success"
    :title="'Downloading ' + selectedMedia.title"
    text="Your download has started successfully!"
  ></v-alert>



    </v-card>
  </v-dialog>
   

  <v-dialog  
       overlay-color="black"
  overlay-opacity="1"
  theme="dark"
  v-if="favorites"
   v-model="favorites" 
   max-width="600">
    <v-card>
      <v-card-title>
       Your Favorites
      </v-card-title>
      <v-list density="compact">
      <v-list-item
        v-for="(item, index) in filteredMedia" 
        :key="index"
        :value="item"
        color="primary"
      >
        <template v-slot:prepend>
          <v-img
  :width="70"
  aspect-ratio="16/9"
  cover
  :src="host + ':' + port + '/cover/' + item.id"
></v-img>
        </template>

        <v-list-item-title v-text="item.title"></v-list-item-title>
      </v-list-item>
    </v-list>
      </v-card>
      </v-dialog>



      <v-dialog  
       overlay-color="black"
  overlay-opacity="1"
  theme="dark"
  v-if="settings"
   v-model="settings" 
   max-width="600">
    <v-card
    height="400"
    >
      <v-card-title>
       Settings ({{ host }}:{{ port }})
      </v-card-title>
      <div class="settings_container" :style="{'overflow-y': 'scroll', 'height': '90%', '--scrollbar-thumb-color': theme_color}">
      <div>
      
          <v-expansion-panels></v-expansion-panels>
        
          <button @click="current_settings != 0? current_settings = 0 : current_settings = 10" class="sec" :style="{color: theme_color}">Dimensions <v-icon v-if="current_settings == 0">mdi-chevron-down</v-icon><v-icon v-if="current_settings != 0">mdi-chevron-right</v-icon></button>
     <div v-if="current_settings == 0">
     
      <v-slider label="Font Size" v-model="font_size" thumb-label  max="40" :color="theme_color"></v-slider>
      
      
              <v-slider v-model="cover_width" :color="theme_color" label="Cover Width" height="50" direction="horizontal" max="400"></v-slider>  
              <v-slider v-model="cover_height" :color="theme_color" label="Cover Height" height="50" direction="horizontal" max="400"></v-slider>
       
    </div>
          <v-divider></v-divider>
          <button @click="current_settings != 1? current_settings = 1 : current_settings = 10" class="sec" :style="{color: theme_color}">Theme  <v-icon v-if="current_settings == 1">mdi-chevron-down</v-icon><v-icon v-if="current_settings != 1">mdi-chevron-right</v-icon></button>
    <div  v-if="current_settings == 1">
            <center>
        <v-color-picker v-model="theme_color" hide-inputs></v-color-picker>
     </center> </div>
      </div>

<v-divider></v-divider>
<button @click="current_settings != 2? current_settings = 2 : current_settings = 10" class="sec" :style="{color: theme_color}">Home Page <v-icon v-if="current_settings == 2">mdi-chevron-down</v-icon><v-icon v-if="current_settings != 2">mdi-chevron-right</v-icon></button>
<div v-if="current_settings == 2">
       <v-container fluid>
          <v-row no-gutters>
      <v-column>
        <v-checkbox v-model="checkedValues" label="All Your Media" :color="theme_color" value="All Your Media"></v-checkbox>
        <v-checkbox v-model="checkedValues" label="Keep Watching" :color="theme_color" value="Keep Watching"></v-checkbox>
        <v-checkbox v-model="checkedValues" label="Movies" :color="theme_color" value="Movies"></v-checkbox>
      </v-column>
      <v-column>
        <v-checkbox v-model="checkedValues" label="Series" :color="theme_color" value="Series"></v-checkbox>
        <v-checkbox v-model="checkedValues" label="Favorites" :color="theme_color" value="Favorites"></v-checkbox>
        <v-checkbox v-model="checkedValues" label="Tag1" :color="theme_color" value="6"></v-checkbox>
      </v-column>
  
    </v-row>
</v-container>
<v-checkbox v-model="show_title" :color="theme_color" label="Show media title on cover"></v-checkbox>


<div class="d-flex picks">
  
  <v-combobox
  :color="theme_color"
  class="episode_pick"
  label="Sort by"
  :items="['Last Added', 'A-Z']"
  variant="outlined"
  v-model="sorting"
  @update:model-value="fetch_all_media"
  ></v-combobox>
  <v-icon size="x-large" v-if="sorting == 'A-Z'">mdi-sort-alphabetical-ascending</v-icon>
  <v-icon size="x-large" v-if="sorting == 'Last Added'">mdi-sort-clock-ascending-outline</v-icon>
  
</div>
</div> 
<v-divider></v-divider>
<button @click="current_settings != 3? current_settings = 3 : current_settings = 10" class="sec" :style="{color: theme_color}"> Server Settings (Requires Admin) <v-icon v-if="current_settings == 2">mdi-chevron-down</v-icon><v-icon v-if="current_settings != 2">mdi-chevron-right</v-icon></button>

<v-btn @click="externalServerPopup = true" color="warning">ACCESS EXTERNAL LIBRARY</v-btn>
</div>
    </v-card>
      </v-dialog>


  </div>

<v-dialog
v-if="externalServerPopup"
v-model="externalServerPopup"
theme="dark"
max-width="400">
<v-card>
  <v-title>External library public IP</v-title>
  
  <v-template>
  <center>
    <v-text-field style="width: '60%' !important;" placeholder="Ex. 129.168.00.000"></v-text-field>
    <v-btn color="primary">Connect</v-btn>
  </center>
</v-template>
</v-card>
</v-dialog>
</template>

<style scoped>
.main{
  margin-left: 0%;
}
video::-webkit-media-controls {
      display: none !important;
    }
h4{
  padding-left: 2%;
}
.actionBtn{
  z-index: 8 !important;
}

.season_pick{
max-width: 120px !important;
}
.sec{
  width: 100%;
  border: 0px solid none !important;
}
.episode_pick{
max-width: 280px !important;
font-size: 2% !important;
}
.reload:hover{
  color: var(--color)
}
video{
 
  width: 100% !important;
  height: 100% !important;
}
#video-container{
  background-color: black;
  position: absolute;
  z-index: 7;
  width: 100% !important;
  margin-top:0%;
  height: 100%;
  overflow: hidden;
}
.main{
  width: 90vw;
}


.settings_container::-webkit-scrollbar {
    width: 10px; 
  }

  .settings_container::-webkit-scrollbar-thumb {
    background-color: var(--scrollbar-thumb-color, gold);
    border-radius: 2px !important;
    height: 2px !important;
 border-bottom: 4px solid #242424; }


  .settings_container::-webkit-scrollbar-track {
    height: 3px !important;
    background-color: transparent; /* Transparent background for the track */
  }


  .d-flex {
    gap: 2% !important;
  }

  .flex-row {
    display: flex;
    width: 100%; 
    margin-top: 1%;
    overflow-x: auto; 
  }

  h2 {
    user-select: none;
  }

 
.text-start{
  margin-top: 2%;
}
.play{
  cursor: pointer;
  position: absolute;
  font-size: 500%;
  z-index: 5;
  border: 2px solid white;
  border-radius: 50px;
  margin-left: 45%;
  margin-top: 9%;
}
.play:hover{
  color: var(--color);
  border: 2px solid var(--color);
}
.v-combobox{
  width: 20% !important;
  margin-left: 2%;
}

@media screen and (max-width: 500px) {
.main{
  position: absolute;
  left: 0;
  top: 0;
margin-left: 1%;
  margin-top: 8%;
}  

.actionBtn{
  font-size: 70% !important;
}

.v-card {
    cursor: pointer !important;
    user-select: none;
  }

  .season_pick{
    display: block;
}
.episode_pick{
max-width: 280px !important;
font-size: 2% !important;
}

 .play{
    margin-left: 40%;
  margin-top: 15%;
  }
  .hello {
  font-size: 120% !important;
 
}

  video{
  position: absolute;
  z-index: 7;
  width: 100%;
  margin-top:-38%;
  height: 60vh;
}
}
</style>
