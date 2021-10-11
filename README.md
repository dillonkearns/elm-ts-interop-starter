# elm-ts-interop starter

## Setup Instructions

You can use the free Community Edition or the paid Pro Edition of `elm-ts-interop`.

The result of running both of these will give you the exact same TypeScript Declaration file as output.

### Community Edition (Free)

```shell
npm install
npm run generate # updates the generated TypeScript Declaration file
npm start # runs the dev server for the example page
```

The demo app is also running at <https://elm-ts-interop-starter.netlify.app/>.

### Pro Edition (Paid)

To setup the pro edition, checkout [the starter repo's `pro` branch](https://github.com/dillonkearns/elm-ts-interop-starter/tree/pro).

Note: in order to run the `elm-ts-interop-pro` executable, you will need to run npm install with your `NPM_TOKEN` environment variable. See the instructions you receive after purchasing your `elm-ts-interop` Pro Edition license for how to get the value for your NPM_TOKEN.

The Pro Edition setup has the following differences:

- There is an [`.npmrc`](https://github.com/dillonkearns/elm-ts-interop-starter/blob/pro/.npmrc) file to wire up your `NPM_TOKEN` to install the pro package
- The [`src/InteropDefinitions.elm`](https://github.com/dillonkearns/elm-ts-interop-starter/blob/pro/src/InteropDefinitions.elm) file uses a different format which is more convenient to maintain (but generates the same output)

Otherwise the Pro and Community Edition setup instructions are exactly the same.
