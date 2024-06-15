/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// const {logger} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// The Firebase Admin SDK to access Firestore.
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
// const {getMessaging} = require("firebase-admin/messaging");
const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
// Imports the Google Cloud Tasks library.
const {v2beta3} = require("@google-cloud/tasks");
const MAX_SCHEDULE_LIMIT = 30 * 60 * 60 * 24;
// Instantiates a client.


initializeApp();
// send notification when a user get invited
// to a board
exports.sendInvitationNotification =
onDocumentCreated("invitations/{invitationId}", async (event) =>{
  const snapshot = event.data;
  if (!snapshot) {
    console.log("No data associate with the event");
    return;
  }
  const invitation = snapshot.data();
  const userDoc = await getFirestore()
      .collection("users").where("email", "==", invitation.invitee)
      .limit(1).get();
  const userData = userDoc.docs[0].data();

  if (userData && userData.token) {
    const deviceToken = userData.token;
    // notification data
    const message = {
      notification: {
        title: "New Invitation",
        body: `You have received a new invitation the board
        ${invitation.boardName}`,
      },
      data: {
        type: "invitation",
        senderEmail: `${invitation.boardOwner}`,
        invitationId: event.data.id,
      },
      token: deviceToken,
    };

    // Send notification
    try {
      await admin.messaging().send(message);
      console.log("Notification sent successfully");
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  } else {
    console.error("No device token found for user:", invitation.invitee);
  }
});

exports.onTaskCreated =
onDocumentCreated("tasks/{taskId}", async (event) => {
  const snapshot = event.data;
  if (!snapshot) {
    console.log("No data associate with the event");
    return;
  }
  const newTask = snapshot.data();
  console.log(newTask);
  // Send notification to assignees
  let assignees = newTask.assignees;
  if (!Array.isArray(assignees)) {
    assignees = [assignees];
  }
  for (const userEmail of assignees) {
    if (userEmail != newTask.creator) {
      const userDoc = await getFirestore().collection("users").
          where("email", "==", userEmail).limit(1).get();
      if (!userDoc.empty) {
        const user = userDoc.docs[0].data();
        const message = {
          notification: {
            title: `New Task Assigned`,
            body: `You have been assigned a new task 
      on the board ${newTask.boardName}.`,
          },
          data: {taskId: event.data.id, type: "New Task"},
          token: user.token,
        };
        await admin.messaging().send(message).then((sent)=> {
          console.log("Notification was sent", sent);
        }).catch((error) =>{
          console.log("Error: ", error);
        });
      }
    }
  }

  // Schedule a notification for the task due date
  const dueDate = newTask.dueDate.toDate();
  const currentDate = Date.now();

  if (dueDate > currentDate) {
    const delay = (dueDate - currentDate)/1000;
    console.log("delay:", delay);
    const payload = {taskId: event.data.id, taskName: newTask.name};
    const convertedPayload = JSON.stringify(payload);
    const body = Buffer.from(convertedPayload).toString("base64");
    const task = {
      httpRequest: {
        httpMethod: "POST",
        url: process.env.FUNCTION_URL,
        headers: {
          "Content-Type": "application/json",
        },
        body,
      },
      scheduleTime: {
        seconds: Math.min(delay, MAX_SCHEDULE_LIMIT) + Date.now() / 1000,
      },
    };
    const client = new v2beta3.CloudTasksClient();
    const parent =
        client.queuePath(process.env.PROJECT,
            process.env.QUEUE_LOCATION, process.env.QUEUE_NAME);
    await client.createTask({parent, task}).then((sent)=> {
      console.log("Task created", sent);
    }).catch((error) =>{
      console.log("Error task: ", error);
    });
  } else {
    console.log("error task creation date:", dueDate);
  }
});

exports.sendDueNotification = onRequest(
    async (req, res) => {
      res.set("Access-Control-Allow-Origin", "*");
      // Decode the base64 string
      const body = req.body;

      const {taskId, taskName} = body;
      const taskDoc = await getFirestore().collection("tasks").
          doc(taskId).get();
      console.log("taskDoc", taskDoc);
      console.log("task data", taskDoc.data());
      if (taskDoc.exists) {
        const task = taskDoc.data();
        let assignees = task.assignees;
        if (!Array.isArray(assignees)) {
          assignees = [assignees];
        }
        for (const userEmail of assignees) {
          const userDoc = await getFirestore().collection("users").
              where("email", "==", userEmail).limit(1).get();
          if (!userDoc.empty) {
            const user = userDoc.docs[0].data();
            console.log("user:", user);
            const message = {
              notification: {
                title: `Task Due: ${taskName}`,
                body: `Your task is due now.`,
              },
              data: {taskId: taskId,
                taskName: taskName, type: "Due"},
              token: user.token,
            };
            await admin.messaging().send(message).then((sent)=> {
              console.log("Notification was sent", sent);
            }).catch((error) =>{
              console.log("Error: ", error);
            });
          }
        }
        res.status(200).send("Due notification sent.");
      } else {
        res.status(404).send("Task not found.");
      }
    });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started


