import config from '../components/config.json'

export async function fetchAll(endpoint: any){


    const it = `${config.url}:${config.port}/${endpoint}`
try{
    const response = await fetch(it)
  const data = await response.json()
  console.log(data)
  return data;
}catch{
  return null;
}
}