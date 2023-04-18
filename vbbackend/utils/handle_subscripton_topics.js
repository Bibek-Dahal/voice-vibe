import User from "../models/user.js";
import { applicationDefault } from "firebase-admin/app";

// compareArray(a,b)

import admin from "firebase-admin";
admin.initializeApp({
  credential: applicationDefault(),
});

function handleSubscription(present_array, new_array, id) {
  console.log("handle sub called");

  //return result based on elements of array
  function compareArray(a, b) {
    let result = a.sort().toString() === b.sort().toString();
    console.log(result);
    return result;
  }

  if (!compareArray(present_array, new_array)) {
    //fav topics has been added
    if (present_array.length < new_array.length) {
      //new topics has been added
      let added_ones = new_array.filter((x) => !present_array.includes(x));
      console.log("added_ones", added_ones);
      subToTopic(added_ones, id);
    } else {
      //topic has been removed
      let removed_ones = present_array.filter((x) => !new_array.includes(x));
      console.log("removed_ones", removed_ones);
      unSubToTopic(removed_ones, id);
    }
  }

  async function subToTopic(topics, id) {
    topics.forEach((element) => console.log("topic subscribed"));

    const user = await User.findOne({ _id: id });
    const registration_tokens = user.fcm_token;
    // Loop through each registration token and subscribe to the topics
    registration_tokens.forEach((token) => {
      topics.forEach((topic) => {
        admin
          .messaging()
          .subscribeToTopic(token, topic)
          .then(() => {
            console.log(
              `Successfully subscribed to topics ${topic} for token ${token}`
            );
          })
          .catch((error) => {
            console.error(
              `Error subscribing to topics ${topic} for token ${token}:`,
              error
            );
          });
      });
    });
  }

  async function unSubToTopic(topics, id) {
    topics.forEach((element) => console.log("topic removed"));

    const user = await User.findOne({ _id: id });
    const registration_tokens = user.fcm_token;
    // Loop through each registration token and subscribe to the topics
    registration_tokens.forEach((token) => {
      topics.forEach((topic) => {
        admin
          .messaging()
          .unsubscribeFromTopic(token, topic)
          .then(() => {
            console.log(
              `Successfully unSubscribed to topics ${topic} for token ${token}`
            );
          })
          .catch((error) => {
            console.error(
              `Error unSubscribing to topics ${topic} for token ${token}:`,
              error
            );
          });
      });
    });
  }
}

export { handleSubscription, admin };
