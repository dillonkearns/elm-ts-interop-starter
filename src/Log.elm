module Log exposing (Kind(..))

import Json.Encode


type Kind
    = Error
    | Warning
    | Info
    | Alert
