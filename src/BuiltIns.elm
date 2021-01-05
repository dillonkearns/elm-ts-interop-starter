module BuiltIns exposing (..)

import TsInterop.Decode as Decode exposing (Decoder)
import TsInterop.Encode as Encode exposing (Encoder)


type Item
    = StringThing String
    | FloatThing Float


itemEncoder : Encoder Item
itemEncoder =
    Encode.union
        (\vStringThing vFloatThing value ->
            case value of
                StringThing data ->
                    vStringThing data

                FloatThing data ->
                    vFloatThing data
        )
        |> Encode.variant Encode.string
        |> Encode.variant Encode.float
        |> Encode.buildUnion


itemDecoder : Decoder Item
itemDecoder =
    Decode.oneOf
        [ Decode.string |> Decode.map StringThing
        , Decode.float |> Decode.map FloatThing
        ]
