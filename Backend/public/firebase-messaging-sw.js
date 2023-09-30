
if ('serviceWorker' in navigator) {

    navigator.serviceWorker.register('../../firebase-messaging-sws.js')
        .then(function(registration) {
            console.log('Registration successful, scope is:', registration.scope);

        }).catch(function(err) {
        console.log('Service worker registration failed, error:', err);
    });
    navigator.serviceWorker.addEventListener('message', event => {
        // event is a MessageEvent object
        console.log(`The service worker sent me a message: ${event.data}`);
    });

    navigator.serviceWorker.ready.then( registration => {
        registration.active.postMessage("Hi service worker");
    });
}

