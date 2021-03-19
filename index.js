document.addEventListener("DOMContentLoaded", function (event) {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: null,
  });
});

/**
 * @param {Elm.ElmApp} app
 * @param {string} portName
 * @param {(portObject: Elm.PortFromElm<unknown>) => void} subscribeFunction
 * @param {() => void} [ onMissing ]
 */
function trySubscribe(app, portName, subscribeFunction, onMissing) {
  const maybePort = app.ports[portName];

  if (maybePort && "subscribe" in maybePort) {
    subscribeFunction(maybePort);
  } else {
    onMissing && onMissing();
  }
}

/**
 * @param {Elm.ElmApp} app
 * @param {string} portName
 * @param {(portObject: Elm.PortToElm<unknown>) => void} sendFunction
 * @param {() => void} [ onMissing ]
 */
function trySend(app, portName, sendFunction, onMissing) {
  const maybePort = app.ports[portName];

  if (maybePort && "send" in maybePort) {
    sendFunction(maybePort);
  } else {
    onMissing && onMissing();
  }
}

function getOsName() {
  if (window.navigator.userAgent.includes("Windows")) {
    return "Windows";
  } else if (window.navigator.userAgent.includes("Mac")) {
    return "Mac";
  } else if (window.navigator.userAgent.includes("Linux")) {
    return "Linux";
  } else {
    return null;
  }
}
