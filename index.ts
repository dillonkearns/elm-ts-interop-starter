import { Elm } from "./src/Main.elm";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: null,
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
