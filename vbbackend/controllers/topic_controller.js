import Topic from "../models/favourite_topic_category.js";

class TopicController {
  static getAllTopics = async (req, res) => {
    try {
      const topics = await Topic.find({});
      res.status(200).send({
        message: "topic fetched successfully",
        data: topics,
        success: true,
      });
    } catch (error) {
      console.log(error);
      res.status(500).send({
        errors: {
          details: ["something went wrong"],
        },
      });
    }
  };
}

export default TopicController;
