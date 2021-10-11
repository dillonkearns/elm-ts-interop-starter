import { Elm } from "./src/Main.elm";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: {
      os: "Windows",
    },
  });
  app.ports.interopFromElm.subscribe((fromElm) => {
    console.log({ fromElm });

    switch (fromElm.tag) {
      case "alert": {
        alert(fromElm.data.message);
        break;
      }
      case "scrollIntoView": {
        document
          .getElementById(fromElm.data.id)
          ?.scrollIntoView(fromElm.data.options);
        break;
      }
      case "user": {
        console.log(fromElm.data);
        break;
      }
      case "relativeTimeFormat": {
        console.log(fromElm.data);
        break;
      }
    }
  });
});
