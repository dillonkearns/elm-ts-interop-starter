/// <reference path="./src/Main/index.d.ts" />

document.addEventListener("DOMContentLoaded", function (event) {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: {
      os: "Windows",
    },
  });
  app.ports.interopFromElm.subscribe((fromElm) => {
    console.log({ fromElm });

    switch (fromElm.tag) {
      case "alert":
        alert(fromElm.data.message);
        break;
      case "scrollIntoView":
        document
          .getElementById(fromElm.data.id)
          ?.scrollIntoView(fromElm.data.options);
        break;
      case "relativeTimeFormat":
        console.log(
          new Intl.RelativeTimeFormat(fromElm.data.options.locales, {
            numeric: "auto",
            style: fromElm.data.options.style,
          }).format(fromElm.data.options.value, fromElm.data.options.unit)
        );
        break;
    }
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
