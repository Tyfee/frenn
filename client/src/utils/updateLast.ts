import configs from '../components/config.json'

const host = configs.url
const port = configs.port

const updateLast = (id: any, position: any) => {
  console.log(`updated ${id} to ${position}`)
    fetch(`${host}:${port}/update_progress`, {
      method: 'POST',
      headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
          "id": id,
          "position": position
        }
      
      ),
    cache: 'default'
  }) .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error('Error:', error));
  }
  

export default updateLast