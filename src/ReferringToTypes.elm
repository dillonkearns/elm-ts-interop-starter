module ReferringToTypes exposing (..)

{-
   type MyObject = { message : string; severity : Severity }

   type Severity = "info" | "warning" | "error";
-}

import Json.Encode as JE
import TsInterop.Decode as Decode exposing (Decoder)
import TsInterop.Encode as Encode exposing (Encoder)


type alias MyObject =
    { message : String, severity : Severity }


myObjectEncoder : Encoder MyObject
myObjectEncoder =
    Encode.object
        [ Encode.required "message" .message Encode.string
        , Encode.required "severity" .severity severityEncoder
        ]


myObjectDecoder : Decoder MyObject
myObjectDecoder =
    Decode.succeed MyObject
        |> Decode.andMap (Decode.field "message" Decode.string)
        |> Decode.andMap (Decode.field "severity" severityDecoder)


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
