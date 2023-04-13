import Profile from "../models/profile.js";
import cloudinary from "../config/cloudinary.js";

class ProfileController {
  static update = async (req, res) => {
    console.log("update called");
    const { id } = req.params;

    try {
      if (req.file) {
        let cloud_res = await cloudinary.v2.uploader.upload(req.file.path, {
          folder: "node",
        });
        req.body.profile_pic = cloud_res.secure_url;
      }
      const profile = await Profile.findById(id);
      if (profile) {
        console.log("inside profile", req.body.profile_pic);
        const update_profile = await profile.updateOne({
          profile_pic: req.body.profile_pic ?? profile.profile_pic,
          favourite_topics:
            req.body.favourite_topics ?? profile.favourite_topics,
          followers: req.body.followers ?? profile.followers,
          following: req.body.following ?? profile.following,
        });
        res.status(200).send({
          message: "profile updated successfully",
          success: true,
        });
      } else {
        res.status(404).send({
          message: "profile not found",
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
  };
}

export default ProfileController;
