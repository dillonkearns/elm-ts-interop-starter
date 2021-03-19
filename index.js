document.addEventListener("DOMContentLoaded", function (event) {
  const app = Elm.Main.init({
    node: document.querySelector("main"),
    flags: null,
  });
});

function getOsName() {
  if (window.navigator.userAgent.includes("Windows")) {
    return "Windows";
  } else if (window.navigator.userAgent.includes("Mac")) {
    return "Mac";
  } else if (window.navigator.userAgent.includes("Linux")) {
    return "Linux";
  } else {
    return null;
  }
}
