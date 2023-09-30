importScripts('https://www.gstatic.com/firebasejs/9.2.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.2.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyA972YXOqd0QXskEjIO2eNWq2O5Xv5MAB0",
    authDomain: "valiant-monitor-352501.firebaseapp.com",
    projectId: "valiant-monitor-352501",
    storageBucket: "valiant-monitor-352501.appspot.com",
    messagingSenderId: "539554129699",
    appId: "1:539554129699:web:5d74263936f0ce76eace96",
    measurementId: "G-2BNQWDDRSS"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    const notificationTitle = 'Background Message Title';
    const notificationOptions = {
        body: 'Background Message body.',
        icon: 'msg.jpg'
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});



