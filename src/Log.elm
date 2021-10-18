module Log exposing (Kind(..), kindEncoder)

import Json.Encode
import TsJson.Encode as TsEncode exposing (Encoder)


type Kind
    = Error
    | Warning
    | Info
    | Alert


kindEncoder : Encoder Kind
kindEncoder =
    TsEncode.union
        (\vError vInfo vWarn vAlert value ->
            case value of
                Error ->
                    vError

                Info ->
                    vInfo

                Warning ->
                    vWarn

                Alert ->
                    vAlert
        )
        |> TsEncode.variantLiteral (Json.Encode.string "error")
        |> TsEncode.variantLiteral (Json.Encode.string "info")
        |> TsEncode.variantLiteral (Json.Encode.string "warn")
        |> TsEncode.variantLiteral (Json.Encode.string "alert")
        |> TsEncode.buildUnion
