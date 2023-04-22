import Queue from "bull";
import { DateTime } from "luxon";
import moment from "moment-timezone";
const space_notification_queue = new Queue("space_notification_queue");
import sendNotification from "./send_notification.js";
import { parse } from "dotenv";

// const { router, setQueues, replaceQueues, addQueue, removeQueue } =
//   createBullBoard([new BullAdapter(space_notification_queue)]);

space_notification_queue.process(async (job, done) => {
  const topics = job.data.topics;
  try {
    await sendNotification(topics);
    done(null, { data: "" });
  } catch (error) {
    console.log(error);
    done(new Error("notification cannot be sent"));
  }
});

async function scheduleTask(schedult_time, topics) {
  console.log("schedule_time", schedult_time);

  // Convert datetime string in Nepal time to UTC
  const nepalTime = moment.tz(schedult_time, "Asia/Kathmandu");
  const utcTime = nepalTime.utc();
  console.log(utcTime);
  console.log(moment.utc());

  const delay = utcTime - moment.utc();
  console.log(delay / 1000);
  // console.log(utcTime.diff(moment.utc()));
  const job = await space_notification_queue.add(
    { topics: topics },
    { delay: delay }
  );
  return job;
  // console.log(job);
}

space_notification_queue.on("completed", (job, result) => {
  console.log(`Job completed with result ${result.data}`);
  // myFirstQueue.close().then(() => {
  //   console.log("Queue closed");
  // });
});

export { space_notification_queue, scheduleTask };
