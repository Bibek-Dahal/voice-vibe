import User from "../models/user.js";
import jwt from "jsonwebtoken";
import { displayMongooseValidationError } from "../utils/display_validation_error.js";
import dotenv from "dotenv";
import sendMail from "../utils/send_mail.js";
import Sms from "../utils/send_sms.js";

dotenv.config();

class UserController {
  //function for registering new user
  static register = async (req, res) => {
    try {
      let user = User(req.body);
      const phone_num = req.body.phone_num;
      try {
        await user.save();
      } catch (error) {
        return displayMongooseValidationError(req, res, error);
      }

      const otp_token = Sms.genOtp();
      Sms.sendOtp(phone_num, otp_token);
      const otp_credential = Sms.genOtpCredential(
        phone_num,
        otp_token,
        15 * 60
      );

      const data = {
        message: "user created successfully",
        otp_credential: otp_credential,
        phone_num: phone_num,
        success: true,
      };

      res.status(201).send(data);
    } catch (error) {
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };
  // }

  //verify otp
  static verifyOtp = async (req, res) => {
    const { phone_num, otp, otp_credential, verification_type } = req.body;

    try {
      console.log("verify called");
      const result = jwt.verify(otp_credential, process.env.JWT_SECRET_KEY);
      //implement else method
      console.log("result: ", result);

      //check if phone_num and otp match
      if (result.phone_num == phone_num && result.otp_token == otp) {
        if (verification_type == "user_verification") {
          const user = await User.findOne({ phone_num: phone_num });
          await User.findByIdAndUpdate(user.id, { is_phn_verified: true });

          return res.status(200).send({
            message: "user verified successfully",
            success: true,
          });
        }

        return res.status(200).send({
          message: "OTP sent successfully",
          success: true,
        });
      } else {
        return res.status(400).send({
          errors: {
            details: ["please enter valid OTP"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(400).send({
        errors: {
          details: ["user cannot be verified"],
        },
        success: false,
      });
    }
  };

  //resend OTP

  /*
  static async resendOtp(req, res) {
    const { phone_num } = req.body;
    try {
      const user = await User.findOne({ phone_num: phone_num });
      console.log("user", user);

      if (user) {
        if (user && !user.is_phn_verified) {
          const otp_token = Sms.genOtp();
          Sms.sendOtp(phone_num, otp_token);
          const otp_credential = Sms.genOtpCredential(phone_num, otp_token);
          res.status(200).send({
            message: "OTP send successfully",
            otp_credential: otp_credential,
            success: true,
          });
        } else {
          res.status(200).send({
            message: "user already verified",
            success: true,
          });
        }
      } else {
        res.status(400).send({
          errors: {
            details: ["please enter valid phone number"],
          },
          success: false,
        });
      }
    } catch (error) {
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  }
  */

  //     //verify user
  //     static verifyUser = async (req,res)=>{
  //         const {userId,token} = req.params
  //         let result;
  //         let id;
  //         try{
  //              try{
  //                 //verify jwt
  //                 result = await jwt.verify(token, process.env.JWT_SECRET_KEY);
  //                 // const decoder = await new Base64Decoder().optimize();
  //                 //decodes the userId
  //                 id = new TextDecoder().decode(new Base64Decoder().decode(userId))

  //              }catch(error){
  //                 return res.status(400).send({message:"Token Expired"});
  //              }

  //              let user = await User.findByIdAndUpdate(id,{is_active:true})
  //              if(result && user){

  //                 await user.save()
  //                 res.redirect('http://127.0.0.1:3000/login?msg=account verified successfully')

  //              }else{
  //                 res.status(400).send({
  //                     message: "user verification failed",
  //                     success : false
  //                 })
  //              }

  //         }catch(error){
  //             console.log(error)
  //             res.status(500).send({
  //                 "message":"something went wrong",
  //             })
  //         }
  //     }

  //     static resendVerificationMail = async (req,res)=>{
  //         try{
  //             console.log(req.body.email)
  //             const user = await User.findOne({email:req.body.email})
  //             console.log(user)
  //             //sends mail if user exists and is_active is false
  //             if(user && user.is_email_verified == false){
  //                 sendMail(user,"User Verification Email")
  //                 res.status(200).send({
  //                     message:"verification email sent",
  //                     success: true
  //                 })
  //             }else{
  //                 //sends mail if user doesnot exist same logic used by other site
  //                 res.status(200).send({
  //                     message:"mail sent",
  //                     success: true
  //                 })
  //             }
  //         }catch(error){
  //             res.status(500).send({
  //                 message:"semithing went wrong"
  //             })
  //         }
  //     }
  /*
          log user
      */

  static async login(req, res) {
    let err = { errors: {} };
    const { phone_num, password } = req.body;

    try {
      console.log("i am inside try");
      let user = await User.findOne({ phone_num: phone_num });
      //check if user doesnot exists
      console.log(!user);
      if (!user) {
        res.status(400).send({
          errors: {
            non_field_errors: [
              "the provided credential does not match our record",
            ],
          },
          success: false,
        });
      } else {
        //check for password if user exists
        let result = await User.checkUser(password, user.password);
        if (result) {
          //determines whether user can login or not
          if (!user.is_phn_verified) {
            res.status(452).send({
              errors: {
                non_field_errors: ["please verify your phone number"],
              },
              success: false,
            });
          } else {
            //log the user
            const token = jwt.sign(
              {
                id: user._id,
              },
              process.env.JWT_SECRET_KEY,
              { expiresIn: 15 * 24 * 60 * 60 }
            );

            res.status(200).send({
              message: "login successful",
              auth_token: token,
              success: true,
              data: {
                id: user._id,
                username: user.username,
                email: user.email,
                phone_num: user.phone_num,
                fcm_token: user.fcm_token,
                is_phn_verified: user.is_phn_verified,
                is_email_verified: user.is_email_verified,
                created_at: user.created_at,
                updated_at: user.updated_at,
              },
            });
          }
        } else {
          //send err if password didnt match
          res.status(400).send({
            errors: {
              non_field_errors: [
                "the provided credential does not match our record",
              ],
            },

            success: false,
          });
        }
      }
    } catch (error) {
      console.log(error);

      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  }

  /*
          password change
      */
  static async passwordChange(req, res) {
    const { old_password, new_password } = req.body;
    let user;
    try {
      user = await User.findById(req.user_id);
      if (!user) {
        return res.status(404).send({
          errors: {
            non_field_errors: ["user not found"],
          },
          success: false,
        });
      }
      let result = await User.checkUser(old_password, user.password);

      try {
        if (result) {
          //change the password
          user.password = new_password;
          await user.save();
          res.status(200).send({
            message: "password changed successfull",
            success: true,
          });
        } else {
          res.status(400).send({
            errors: {
              non_field_errors: [
                "old password does not match current password",
              ],
            },
            success: false,
          });
        }
      } catch (error) {
        displayMongooseValidationError(req, res, error);
      }
    } catch (error) {
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  }

  /*
          send password reset otp
      */

  static async resendOtp(req, res) {
    const { phone_num } = req.body;
    console.log(phone_num);

    try {
      let user = await User.findOne({ phone_num: phone_num });
      console.log(user);
      if (user !== null) {
        const otp_token = Sms.genOtp();
        Sms.sendOtp(phone_num, otp_token);
        const otp_credential = Sms.genOtpCredential(
          phone_num,
          otp_token,
          60 * 2
        );

        const data = {
          message: "OTP sent successfully",
          pwd_reset_otp_credential: otp_credential,
          phone_num: phone_num,
          success: true,
        };
        //sent mail
        res.status(200).send(data);
      } else {
        res.status(404).send({
          errors: {
            details: ["user not found"],
          },

          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  }

  /*
      Reset user password
      */
  static async passwordReset(req, res) {
    // const { userId, token } = req.params;
    const { new_password, repeat_password, phone_num } = req.body;

    try {
      let result;
      let id;

      try {
        const user = await User.findOne({ phone_num: phone_num });

        //checks if user is present and token is valid
        if (user) {
          //reset user password
          user.password = new_password;
          await user.save();
          // const update = await user.updateOne({
          //   password: new_password,
          // });

          res.status(200).send({
            message: "password reseted successfull",
            success: true,
          });
        } else {
          res.status(400).send({
            errors: {
              non_field_errors: ["password cannot be reseted"],
            },

            success: true,
          });
        }
      } catch (error) {
        console.log(error);
        displayMongooseValidationError(req, res, error);
      }
    } catch (error) {
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  }

  static async getUserById(req, res) {
    console.log("get user by id called");
    const { id } = req.params;
    try {
      const user = await User.findById(id, { password: 0 });
      if (user) {
        res.status(200).send({
          message: "user found",
          data: user,
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["user not found"],
          },
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went worng"],
        },
      });
    }
  }

  static async getUser(req, res) {
    try {
      const user = await User.findById(req.user_id, { password: 0 });
      // const populated_user = await user.populate("profile");
      // console.log(populated_user);
      if (user) {
        res.status(200).send({
          message: "user found",
          data: user,
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["user not found"],
          },
          success: false,
        });
      }
    } catch (error) {
      console.logI(error);
      res.status(500).send({
        errors: {
          details: ["something went worng"],
        },
        success: false,
      });
    }
  }

  static async updateUser(req, res) {
    const { id } = req.params;
    console.log("id", id);
    try {
      const user = await User.findOne({ _id: id });
      console.log(user);

      if (user) {
        console.log(user);
        if (user._id == req.user_id) {
          //check if user with uname already exists
          if (req.body.username) {
            let checkUname = await User.findOne({
              username: req.body.usernama,
            });
            if (checkUname) {
              return res.status(400).send({
                errors: {
                  non_field_errors: ["user with username already exists"],
                },
              });
            }
          }

          await user.updateOne({
            username: req.body.username ?? user.username,
            fcm_token: req.body.fcm_token ?? user.fcm_token,
          });

          res.status(200).send({
            message: "user updated successfully",
            success: true,
          });
        } else {
          res.status(403).send({
            errors: {
              details: ["forbidden"],
            },

            success: false,
          });
        }
      } else {
        res.status(404).send({
          message: "user not found",
          success: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(500).send({
        message: "something went wrong",
        status: false,
      });
    }
  }

  static async retriveAllUser(req, res) {
    try {
      const users = await User.find(
        { _id: { $ne: req.user_id } },
        { password: 0 }
      );
      console.log(users);
      res.status(200).send({
        data: users,
        message: "fetched user",
        success: true,
      });
    } catch (error) {
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  }
}

export default UserController;
