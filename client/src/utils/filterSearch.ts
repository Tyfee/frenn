import { fetchAll } from "./fetchAll"

const filterSearch = async (search: any) => {

 var final = ''
 const  arr = await fetchAll('all')
 
 if(search != ''){
 const results = arr.filter((result: any) => result['title'].toLowerCase().includes(search.toLowerCase() || result['desc'].toLowerCase().includes(search.toLowerCase())))
     final = results;
 }else{
    final = arr
 }

   return final

}

export default filterSearch
