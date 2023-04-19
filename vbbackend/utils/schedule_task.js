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

  //   const parsedDateTime = moment.tz(
  //     schedult_time,
  //     "YYYY-MM-DD HH:mm:ss",
  //     "Asia/Kathmandu"
  //   );

  const parsedDateTime = DateTime.fromISO(schedult_time, { locale: true });

  console.log("PD", parsedDateTime);

  const fdate = Date(schedult_time);
  console.log(fdate.toString());

  const current_time = Date.now();
  //   console.log(parsedDateTime);
  //   console.log(current_time);
  //   const p = parsedDateTime.valueOf();

  //   console.log(parsedDateTime.valueOf() - current_time);

  const delay = parsedDateTime.ts - current_time;
  console.log(delay);

  const job = await space_notification_queue.add(
    { topics: topics },
    { delay: 10000 }
  );
  console.log(job);
}

space_notification_queue.on("completed", (job, result) => {
  console.log(`Job completed with result ${result.data}`);
  // myFirstQueue.close().then(() => {
  //   console.log("Queue closed");
  // });
});

export { space_notification_queue, scheduleTask };
