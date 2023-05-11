import cloudinary from "../config/cloudinary.js";
import streamifier from "streamifier";

let uploadFromBuffer = (buffer, resource_type = "image", folder = "images") => {
  return new Promise((resolve, reject) => {
    let cld_upload_stream = cloudinary.v2.uploader.upload_stream(
      {
        resource_type: "auto",
        folder: folder,
      },
      (error, result) => {
        if (result) {
          resolve(result);
        } else {
          reject(error);
        }
      }
    );

    streamifier.createReadStream(buffer).pipe(cld_upload_stream);
  });
};

export default uploadFromBuffer;
