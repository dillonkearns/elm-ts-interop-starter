module Log exposing (Kind(..), encoder, toString)

import Json.Encode
import TsJson.Encode as TsEncode exposing (Encoder)


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


encoder : Encoder Kind
encoder =
    TsEncode.union
        (\vError vWarning vInfo vAlert value ->
            case value of
                Error ->
                    vError

                Warning ->
                    vWarning

                Info ->
                    vInfo

                Alert ->
                    vAlert
        )
        |> TsEncode.variantLiteral (Json.Encode.string "error")
        |> TsEncode.variantLiteral (Json.Encode.string "warn")
        |> TsEncode.variantLiteral (Json.Encode.string "info")
        |> TsEncode.variantLiteral (Json.Encode.string "alert")
        |> TsEncode.buildUnion
