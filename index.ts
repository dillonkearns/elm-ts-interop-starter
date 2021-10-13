import { Elm } from "./src/Main.elm";

document.addEventListener("DOMContentLoaded", function () {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: null,
  });
});
