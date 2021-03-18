module Severity exposing (..)

import Json.Encode as JE
import TsJson.Decode as Decode exposing (Decoder)
import TsJson.Encode as Encode exposing (Encoder)


type Severity
    = Info
    | Warning
    | Error


severityEncoder : Encoder Severity
severityEncoder =
    Encode.union
        (\vInfo vWarning vError value ->
            case value of
                Info ->
                    vInfo

                Warning ->
                    vWarning

                Error ->
                    vError
        )
        |> Encode.variantLiteral (JE.string "info")
        |> Encode.variantLiteral (JE.string "warning")
        |> Encode.variantLiteral (JE.string "error")
        |> Encode.buildUnion


severityDecoder : Decoder Severity
severityDecoder =
    Decode.oneOf
        [ Decode.literal Info (JE.string "info")
        , Decode.literal Warning (JE.string "warning")
        , Decode.literal Error (JE.string "error")
        ]
