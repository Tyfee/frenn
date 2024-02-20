

import configs from '../components/config.json'

const host = configs.url
const port = configs.port

const addFav = (id: any) =>{
    fetch(`${host}:${port}/add_favorite`, {
     method: 'POST',
     headers: {
     Accept: 'application/json',
     'Content-Type': 'application/json'
   },
   body: JSON.stringify({"id": id}),
   cache: 'default'
 }) .then(response => response.json())
   .then(data => console.log(data))
   .catch(error => console.error('Error:', error));
 }

 export default addFav