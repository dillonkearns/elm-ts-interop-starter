import { Elm } from "./src/Main";
import Bugsnag, { NotifiableError, Event } from "@bugsnag/js";

const app = Elm.Main.init({
  node: document.querySelector("main"),
  flags: null,
});

app.ports.fromElm.subscribe((fromElm) => {
  console.log({ fromElm });

  switch (fromElm.tag) {
    case "Alert":
      alert(fromElm.message);
      break;
    case "SendPresenceHeartbeat":
      break;
    case "ScrollIntoView":
      document.getElementById(fromElm.id)?.scrollIntoView(fromElm.options);
      break;
  }
});
