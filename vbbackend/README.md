# Voice Vibe

# Auth Routes

## 1. Register

    data = {
        "username": "",
        "email": "",
        "phone_num":""
        "password": "",
        "repeat_password": ""
    }

    axios.post('http://127.0.0.1:8000/api/register',data)

## 2. Login

    data = {
        "phone_num":"",
        "password":""
    }

    axios.post('http://127.0.0.1:8000/api/login',data)

## 3. password change

    data = {
        "old_password":"Admin@1234",
        "new_password":"Admin@123",
        "repeat_password":"Admin@123"
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.post('/api/password-change',data,options)

## 4. Verify OTP

    data = {
        "phone_num":"",
        "otp":590491,
        "otp_credential":"<received-after-registration>",
        "verification_type":"user_verification"
    }

    axios.post('/api/verify-otp',data)

## 5. Resend OTP

    data = {
        "phone_num":""
    }

    axios.post('/api/send-otp')

## 5. Password Reset

    data = {
        "phone_num":"+9779864996631",
        "repeat_password":"Admin@1234",
        "new_password":"Admin@1234"
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.post('/api/password-reset',data,options)

# Profile Routes

## 1. Update Profile

    data = {
        "profile_pic":"",
        "followers":"",
        "following":""
        "favourite_topics":["Nala","Banepa"]
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.patch('/api/profile/<profile-id>',data,options)

## 2. Get Profile By Id

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/profile/<profile-id>',options)

## 3. Get Logged User Profile

    options = {
        headers:{
            'Content-Type':'application/json',              'Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/profile',options)

## 4. Retrive all profile except logged user

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/profile/retrive-all-profile',options)

## 5. List all profile with given list

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    data = {
        "user_list":[]
    }

    axios.post('/api/profile/retrive-profile-with-list',data,options)

# User

## 1. Get User By Id

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/user/<user-id>',options)

## 2. Get All Users

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/user/retrive-all-user',options)

## 3. Get Logged User

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/user',options)

## 4. Update User

    data = {
        "username":"",
        "fcm_token":""
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.patch('/api/user/<user-id>',data,options)

# Chat

## 1. Fetch Chats

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('/api/chat/<profile-id>',options)

# Space

## 1. Create Space

    data = {
        "title":"bibek test job",
        "description":<optional>,
        "schedule_date":"2023-04-22T15:51:00.00",
        "space_topics":[]
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.post('api/space',data,options)

## 2. Update Space

    data = {
        "title":"bibek test job",
        "description":<optional>,
        "schedule_date":"2023-04-22T15:51:00.00",
        "space_topics":[]
    }

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.patch('api/space/<space-id>',data,options)

## 3. Fetch All Space of Current User

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }
    axios.get('api/space/get-all-space-of-user',options)

## 4. Delete Space

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.delete('api/space/<space-id>',options)

## 5. Get Space By Id

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.delete('api/space/<space-id>',options)

## 3. Fetch All Space

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }


    axios.get('api/space/get-all-space',options)

# Topic

## 1. Get All Topics

    options = {
        headers:{
            'Content-Type':'application/json','Authorization':`Bearer ${access_token}`
        }
    }

    axios.get('api/topic',options)
