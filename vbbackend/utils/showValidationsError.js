import Joi from "joi";

//function for displaying error
const showValidationsError = async (req,res,next,schema)=>{

    // const { error, value } = schema.validate(req.body,{abortEarly:false,errors:{label:'key'},wrap: {label: false},allowUnknown:true});
    /*try{
        const value = await schema.validateAsync(req.body,{abortEarly:false,errors:{label:'key'},wrap: {label: false}});
        next()

    }catch(error){
        console.log('hello inside showValError')
        // console.log(error)
        const err = error.details

        let validationErrors = {}
        err.forEach((item) => {
            validationErrors[item.context.key] = item.message
        });
        res.status(400).send(
            {
                errors:{...validationErrors},
                success:false
            }
        ) 
    }*/
    const { error, value } = await schema.validate(req.body,{abortEarly:false,errors:{label:'key'},wrap: {label: false}});
    if(!error){
        next()
    }else{
        console.log(Joi.any)
        console.log(error.details)
        const err = error.details

        let validationErrors = {}
        err.forEach((item) => {
            validationErrors[item.context.key] = item.message
        });
        res.status(400).send(
            {
                errors:{...validationErrors},
                success:false
            }
        ) 
    }
}

export default showValidationsError