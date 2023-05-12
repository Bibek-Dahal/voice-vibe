import Profile from "../models/profile.js";
import cloudinary from "../config/cloudinary.js";

class ProfileController {
  static update = async (req, res) => {
    console.log("update called");
    const { id } = req.params;
    console.log("id", id);
    try {
      const profile = await Profile.findOne({ _id: id });
      console.log(profile);

      if (profile) {
        console.log(profile);
        if (profile.user == req.user_id) {
          // console.log("inside profile", req.body.profile_pic);

          if (req.file) {
            let cloud_res = await cloudinary.v2.uploader.upload(req.file.path, {
              folder: "node",
            });
            req.body.profile_pic = cloud_res.secure_url;
          }

          profile.profile_pic = req.body.profile_pic ?? profile.profile_pic;
          profile.favourite_topics =
            req.body.favourite_topics ?? profile.favourite_topics;
          profile.followers = req.body.followers ?? profile.followers;
          profile.following = req.body.following ?? profile.following;

          // profile.save({
          //   profile_pic: req.body.profile_pic ?? profile.profile_pic,
          //   favourite_topics:
          //     req.body.favourite_topics ?? profile.favourite_topics,
          //   followers: req.body.followers ?? profile.followers,
          //   following: req.body.following ?? profile.following,
          // });
          profile.save();

          res.status(200).send({
            message: "profile updated successfully",
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

  static async getProfileById(req, res) {
    console.log("get user by id called");
    const { id } = req.params;
    try {
      const profile = await Profile.findById(id, { password: 0 });
      if (profile) {
        res.status(200).send({
          message: "profile fetched",
          data: profile,
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

  static async getProfile(req, res) {
    try {
      console.log(req.user_id);
      const profile = await Profile.findOne(
        { user: req.user_id },
        { password: 0 }
      );
      // .populate(
      //   "user",
      //   "username email phone_num fcm_token is_phn_verified is_email_verified created_at updated_at"
      // );
      if (profile) {
        res.status(200).send({
          message: "",
          data: profile,
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

  static async retriveAllProfile(req, res) {
    try {
      const profile = await Profile.find({ user: { $ne: req.user_id } });
      console.log(profile);
      res.status(200).send({
        data: profile,
        message: "fetched profile",
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  }

  static async retriveProfileWithList(req, res) {
    try {
      const profiles = await Profile.find({
        user: { $in: req.body.user_list },
      });
      console.log(profiles);
      res.status(200).send({
        data: profiles,
        message: "profile fetched",
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
        success: false,
      });
    }
  }

  static followProfile = async (req, res) => {
    const { id } = req.params;
    try {
      const following_profile = await Profile.findById(id);

      if (following_profile) {
        await Profile.updateOne(
          { _id: req.profile_id },
          { $push: { following: id } }
        );

        await Profile.updateOne({ _id: id }, { $push: { followers: id } });

        res.status(200).send({
          message: "following successfull",
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["profile not found"],
          },
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
  };

  static unfollowProfile = async (req, res) => {
    const { id } = req.params;
    try {
      const following_profile = await Profile.findById(id);

      if (following_profile) {
        await Profile.updateOne(
          { _id: req.profile_id },
          { $pull: { following: id } }
        );

        await Profile.updateOne({ _id: id }, { $pull: { followers: id } });

        res.status(200).send({
          message: "following successfull",
          success: true,
        });
      } else {
        res.status(404).send({
          errors: {
            details: ["profile not found"],
          },
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
  };
}

export default ProfileController;
