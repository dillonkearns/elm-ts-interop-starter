import { Elm } from "./src/Main.elm";
import { attemptLogin } from "./auth";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: {
      width: 123,
      height: 123,
    },
  });
  app.ports.interopFromElm.subscribe((fromElm) => {
    switch (fromElm.tag) {
      case "alert": {
        if (fromElm.data.logKind === "alert") {
          alert(fromElm.data.message);
        } else {
          console[fromElm.data.logKind](fromElm.data.message);
        }
        break;
      }
      case "attemptLogIn": {
        console.log("Attempting log in...");
        const user = attemptLogin(fromElm.data.username);
        if (user) {
          app.ports.interopToElm.send({
            tag: "authenticatedUser",
            data: { user: user },
          });
        }
      }
    }
  });
});
