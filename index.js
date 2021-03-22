/// <reference path="./src/Main/index.d.ts" />

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
      case "alert":
        alert(fromElm.data);
        break;
      case "scrollIntoView":
        document
          .getElementById(fromElm.data.id)
          ?.scrollIntoView(fromElm.data.options);
        break;
    }
  });
});
