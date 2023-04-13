import mongoose from "mongoose"

const connectDb =  async(uri,options)=>{
    try{
        
        await mongoose.connect(uri,options)
        console.log('Database Connection Successful')
    }catch(err){
        
        console.log('Cannot Connect To DB')
    }
}

export default connectDb