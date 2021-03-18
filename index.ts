import { Elm } from "./src/Main";
import Bugsnag, { NotifiableError, Event } from "@bugsnag/js";

const error: NotifiableError = {
  errorClass: "",
  errorMessage: "",
};
Bugsnag.notify(error);

const app = Elm.Main.init({
  node: document.querySelector("main"),
  flags: null,
});

console.log(app);

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
