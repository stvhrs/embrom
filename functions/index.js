const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.charriehopkins = functions.firestore
    .document("messages/{groupId1}/{groupId2}/{message}")
    .onCreate((snap) => {
      console.log("----------------start function--------------------");
      const doc = snap.data();
      console.log(doc);
      const idFrom = doc.idFrom;
      const idTo = doc.idTo;
      const contentMessage = doc.message;
      const imageMessage= doc.image;
      // Get push token user to (receive)
      admin
          .firestore()
          .collection("users")
          .where("id", "==", idTo)
          .get()
          .then((querySnapshot) => {
            querySnapshot.forEach((userTo) => {
              console.log(`Found user to: ${userTo.data().nickname}`);
              // eslint-disable-next-line max-len
              if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
                // Get info user from (sent)
                admin
                    .firestore()
                    .collection("users")
                    .where("id", "==", idFrom)
                    .get()
                    .then((querySnapshot2) => {
                      querySnapshot2.forEach((userFrom) => {
                        // eslint-disable-next-line max-len
                        console.log(`Found user from: ${userFrom.data().nickname}`);
                        const payload = {
                          notification: {
                            // eslint-disable-next-line max-len
                            title: `You have a message from "${userFrom.data().nickname}"`,
                            body: contentMessage,
                            image: imageMessage,
                            // idTo: userFrom.data().idTo,
                            // idFrom: userFrom.data().idFrom,
                            badge: "1",
                            sound: "default",
                            // Image: "https://d17ivq9b7rppb3.cloudfront.net/original/academy/memulai_pemrograman_dengan_dart_logo_230421132631.jpg",
                          },
                          data: {
                            "userFrom": userFrom.data().nickname,
                            "userTo": userTo.data().nickname,
                            "groupId": snap.id,
                            "idTo": idTo,
                            "idFrom": idFrom,
                          },
                        };
                        // Let push to the target device
                        admin
                            .messaging()
                            .sendToDevice(userTo.data().pushToken, payload)
                            .then((response) => {
                              // eslint-disable-next-line max-len
                              console.log("Successfully sent message:", response);
                            })
                            .catch((error) => {
                              console.log("Error sending message:", error);
                            });
                      });
                    });
              } else {
                console.log("Can not find pushToken target user");
              }
            });
          });
      return null;
    });
