import dotenv from "dotenv";
import twilio from "twilio";
import jwt from "jsonwebtoken";
dotenv.config();

class Sms {
  static sendOtp = (phoneNumber, otp) => {
    const accountSid = process.env.TWILIO_ACCOUNT_SID;
    const authToken = process.env.TWILIO_AUTH_TOKEN;
    const client = twilio(accountSid, authToken);
    console.log("accountSid", authToken);

    // Send OTP via Twilio
    client.messages
      .create({
        body: `Your OTP is ${otp}`,
        from: "+15076688314",
        to: phoneNumber,
      })
      .then((message) => {
        console.log(message.sid);
        // res.send({ success: true, message: "OTP sent successfully" });
      })
      .catch((error) => {
        console.error(error);
        // res.send({ success: false, message: "Failed to send OTP" });
      });
  };

  static genOtp = () => {
    const digits = "0123456789";
    let otp = "";
    for (let i = 0; i < 6; i++) {
      otp += digits[Math.floor(Math.random() * 10)];
    }
    return parseInt(otp);
  };

  static genOtpCredential = (phone_num, otp_token, expiresIn) => {
    const otp_credential = jwt.sign(
      {
        otp_token: otp_token,
        phone_num: phone_num,
      },
      process.env.JWT_SECRET_KEY,
      { expiresIn: 15 * 60 }
    );
    return otp_credential;
  };
}

export default Sms;
