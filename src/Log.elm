module Log exposing (Kind(..), toString)

import Json.Encode


type Kind
    = Error
    | Warning
    | Info
    | Alert


toString : Kind -> String
toString kind =
    case kind of
        Error ->
            "error"

        Warning ->
            "warning"

        Info ->
            "info"

        Alert ->
            "alert"
