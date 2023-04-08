const functions = require('firebase-functions');

const OneSignal = require('onesignal-node');
const app = new OneSignal.App({
  appId: '9d1ab171-68a5-4e18-b027-f9ccbdfd2953',
  apiKey: 'NzI2MmQ3MTItM2E2Ni00ZWVhLWI2MWEtODk5NzA2YWM1NjRl',
});

exports.sendPushNotification = functions.firestore
    .document('updates/{updateId}')
    .onWrite(async (change, context) => {
      const newValue = change.after.data();

      // Determine the message
      let message;
      if (!change.before.exists) {
        message = 'New update added!';
      } else if (change.before.data().status !== newValue.status) {
        message = `Update status changed to ${newValue.status}`;
      } else {
        return null; // No relevant changes, do not send a notification
      }

      // Create a notification object
      const notification = new OneSignal.Notification({
        contents: {
          en: message,
        },
        included_segments: ['All'],
      });

      // Send the notification
      return app.sendNotification(notification);
    });
