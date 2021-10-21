export function attemptLogin(
  username: string
): { username: string; avatarUrl: string } | undefined {
  const avatarUrl = {
    jeanluc:
      "https://labs.engineering.asu.edu/trek-demo/wp-content/uploads/sites/2/2018/12/piccard_square-400x400.jpg",
    dillonkearns: "https://avatars.githubusercontent.com/u/1384166?s=96&v=4",
  }[username];
  if (avatarUrl) {
    return { username, avatarUrl };
  } else {
    return undefined;
  }
}
