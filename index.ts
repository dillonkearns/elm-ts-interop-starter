import { Elm } from "./src/Main.elm";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: {
      dimensions: {
        width: window.innerWidth,
        height: window.innerHeight,
      },
    },
  });

  app.ports.interopFromElm.subscribe(async (fromElm) => {
    switch (fromElm.tag) {
      case "alert": {
        const logKind = fromElm.data.kind;
        if (logKind === "alert") {
          alert(fromElm.data.message);
        } else {
          console[logKind](fromElm.data.message);
        }
        break;
      }
      case "attemptLogIn": {
        const avatarUrl = await attemptLogIn(fromElm.data.username);
        if (avatarUrl) {
          app.ports.interopToElm.send({
            tag: "authenticatedUser",
            username: fromElm.data.username,
            avatarUrl,
          });
        } else {
          app.ports.interopToElm.send({
            tag: "userNotFound",
          });
        }
      }
    }
  });
});

async function attemptLogIn(username: string): Promise<string | undefined> {
  await waitFor(0);
  return {
    jeanluc:
      "https://labs.engineering.asu.edu/trek-demo/wp-content/uploads/sites/2/2018/12/piccard_square-400x400.jpg",
    dillonkearns: "https://avatars.githubusercontent.com/u/1384166?s=96&v=4",
  }[username];
}

function waitFor(ms: number) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}
