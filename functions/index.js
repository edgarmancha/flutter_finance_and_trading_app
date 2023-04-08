const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const OneSignal = require('onesignal-node');
const oneSignalClient = new OneSignal.Client({
  userAuthKey: 'MDZmOTJlOWItNWFhNC00MDhjLTg5YzktOGMwMmUwZTZiNWM2',
  app: {
    appAuthKey: 'NzI2MmQ3MTItM2E2Ni00ZWVhLWI2MWEtODk5NzA2YWM1NjRl',
    appId: '9d1ab171-68a5-4e18-b027-f9ccbdfd2953'},
});

exports.sendNotificationOnUpdate = functions.firestore
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

      // Send the notification to all users
      const notification = new OneSignal.Notification({
        headings: {en: 'Updates'},
        contents: {en: message},
        included_segments: ['All'],
      });

      return oneSignalClient.createNotification(notification);
    });
