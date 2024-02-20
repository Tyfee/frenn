<script setup lang="ts">
import { defineProps, onMounted, ref } from 'vue'
import CaptionDialog from './CaptionDialog.vue';
var prevClientX = 0
onMounted(() => {
   Ignite()


   
})

const props = defineProps(
['id', 'prop', 'color', 'title', 'file', 'playAction', 'fullscreenAction', 'closeAction', 'playing', 'currentPosition', 'currentPositionRaw', 'duration', 'handleChangePosition']
)
const is_nav = ref(false)
const is_sound = ref(false)
const nav_value = ref(0)
const balloon_pos = ref(0)
const seeing_captions = ref(false)
const is_mute = ref(false)
const top_margin = ref('-600%')
const is_fullscreen = ref(false);


function Ignite() {

  return props;
}

const emitChangePosition = () => {
      // Emit a custom event with the nav_value as the parameter
      this.$emit('change-position', nav_value);
    }
const adjustToFullscreen = () => {
  if(!is_fullscreen.value){
   top_margin.value = '-750%';
}
if(is_fullscreen.value){
   top_margin.value = '-600%';
}
}
    const handleFullscreen = () => {
      props.fullscreenAction()
      adjustToFullscreen();
      if(is_fullscreen.value == false){
        is_fullscreen.value = true;
      }
      if(is_fullscreen.value == true){
        is_fullscreen.value = false;
      }
    }
    const handleMove = (e) => {
  if (is_nav) {
    const mouseX = e.clientX;
    const direction = mouseX > prevClientX ? 'right' : 'left';
    const progressRatio = mouseX / window.innerWidth;

    nav_value.value = (props.duration * progressRatio) - (props.duration / 10);

    // Calculate balloon_pos based on the mouse position in vw
    const viewportWidth = window.innerWidth || document.documentElement.clientWidth;
    balloon_pos.value = (mouseX / viewportWidth) * mouseX / (window.innerWidth / 200);
  }
};
</script>

<template>
    
    <div id="controller" class="videoController">

        <caption-dialog
        :id="props.id"
        v-model="seeing_captions"
        v-if="seeing_captions"
        />
        <v-icon @click="closeAction" :color="color" class="close" size="x-large">mdi-close</v-icon>
   
        <div class="videoActions d-flex">
            <div :style="{top: top_margin}" class="headerControls"> 
               
            <h1 class="watching" :style="'color: ' + color">{{ props.title }}</h1>
            <p class="text-start filename">{{ $props.file }}</p>
           
        </div>
        <div  style="display: flex; width: 100% !important">


            <strong style="margin-bottom: 5%;" class="durationContainer" >
{{ Math.floor(currentPositionRaw / 3600).toString().padStart(2, '0') }}:{{ Math.floor((currentPositionRaw % 3600) / 60).toString().padStart(2, '0') }}:{{ (Math.floor(currentPositionRaw) % 60).toString().padStart(2, '0') }} / {{ Math.floor(duration / 3600).toString().padStart(2, '0') }}:{{ (Math.floor(duration % 3600 / 60).toString().padStart(2, '0')) }}:{{ Math.floor(duration % 60) }}
</strong><v-progress-linear   @click="emitChangePosition" @mousemove="handleMove" @mouseout="is_nav = false" @mouseover="is_nav = true" class="progress" :model-value="$props.currentPosition" :height="10" :color="color"></v-progress-linear>   

<div class="bottomContainers d-flex">
  <div style="width: 30%" class="d-flex">
<v-icon v-if="$props.playing == false" @click="playAction" :color="color" class="play" size="x-large">mdi-play</v-icon>
<v-icon v-if="$props.playing == true" @click="playAction" :color="color" class="play" size="x-large">mdi-pause</v-icon>
<v-icon @click="seeing_captions = true" :color="color" class="cc" size="x-large">mdi-closed-caption</v-icon>
<v-icon v-if="!is_mute" @click="is_mute = !is_mute"  @mouseover="is_sound = !is_sound"  :color="color" class="cc" size="x-large">mdi-volume-high</v-icon>
<v-icon v-if="is_mute" @click="is_mute = !is_mute"  :color="color" class="cc" size="x-large">mdi-volume-off</v-icon>

<v-slider v-if="is_sound && !is_mute" :color="props.color" class="soundBalloon"></v-slider>
</div>

<v-icon @click="handleFullscreen" :color="color" class="fullscreen" size="x-large">mdi-fullscreen</v-icon>
</div>
<div :style="{'background-color': props.color, 'margin-left': balloon_pos + '%'}" v-if="is_nav" class="timeBalloon">
    {{ Math.floor(nav_value / 3600).toString().padStart(2, '0') }}:{{ Math.floor((nav_value % 3600) / 60).toString().padStart(2, '0') }}:{{ (Math.floor(nav_value) % 60).toString().padStart(2, '0') }}
</div>

</div>
   </div>
   </div> 
   
  
</template>

<style scoped>


strong{
font-size: 70% !important;
flex-wrap: nowrap;
text-wrap: nowrap;
}
.bottomContainers{
  left: 0;
  align-items: center;
  bottom: 0;
  position: absolute;
  align-self: start;
  width: 100%;
}
.videoController{
    width: 90%;
    height: 100%;
    position: absolute !important;
    z-index: 5;
    user-select: none;
    
   
}
:-webkit-full-screen .videoController,
:-moz-full-screen .videoController,
:-ms-fullscreen .videoController,
:fullscreen .videoController {
    position: fixed !important;
    width: 100% !important;
    height: 100% !important;
    top: 0;
    left: 0;
}
.timeBalloon{
    border-radius: 20%;
    width: 12%;
    height: 100%;
    position: absolute;
    bottom: 120%;
    
    z-index: 4;
}

.soundBalloon{
   margin-left:1.2vw !important;
    width: 6vw !important;
    height: 5.5vh;
}
.progress{
    cursor: pointer;
    margin-left: -10%;
    width: 70%;
}
.fullscreen{
position: absolute;
right: 0;
}
.videoActions{
    position: absolute !important;
    bottom: 0;
   
    display: flex;
    width: 110%;
    text-align: center;
    justify-content: space-between;
    align-items: center;
    background-color: #232323cd;
}
.v-icon{
    cursor: pointer;
}

.headerControls{
    position: absolute !important;
    z-index: 4 !important;
   
left: 0;
margin-left: 2%;
}
.filename{
    margin-top: 3%;
    font-size: 50%;
}

.rightActions{
   gap: 5%;
}
.close{
    position: absolute !important;
    z-index: 4 !important;
    margin-top: 1% !important;
left: 104%;
margin-left: 0%;
}
</style>