import { Elm } from "./src/Main.elm";
import { attemptLogin } from "./auth";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: null,
  });
  app.ports.alert.subscribe((message) => alert(message));
  app.ports.logIn.subscribe(() =>
    app.ports.onAuthenticated.send("dillonkearns")
  );
});
