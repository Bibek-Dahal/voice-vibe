import { admin } from "./handle_subscripton_topics.js";

async function sendNotification(topics) {
  console.log("send notification called");
  topics.forEach(async (topic) => {
    console.log(topic);
    await admin.messaging().send({
      topic: topic,
      data: {
        hello: "world",
      },

      notification: {
        title: "hello",
        body: "hello this is me bibek",
      },
      // Set Android priority to "high"
      android: {
        priority: "high",
      },
    });
  });
}

export default sendNotification;
