module TupleGenerated exposing (..)

import Json.Encode as JE
import TsInterop.Decode as Decode exposing (Decoder)
import TsInterop.Encode as Encode exposing (Encoder)



--[number, string]


myArrayIndexTypeEncoder : Encoder ( Float, String )
myArrayIndexTypeEncoder =
    Encode.tuple
        Encode.float
        Encode.string


myArrayIndexTypeDecoder : Decoder ( Float, String )
myArrayIndexTypeDecoder =
    Decode.succeed Tuple.pair
        |> Decode.andMap Decode.float
        |> Decode.andMap Decode.string


myTripleTypeEncoder : Encoder ( Float, String, String )
myTripleTypeEncoder =
    Encode.triple
        Encode.float
        Encode.string
        Encode.string


myTripleTypeTypeDecoder : Decoder ( Float, String, String )
myTripleTypeTypeDecoder =
    Decode.succeed (\a b c -> ( a, b, c ))
        |> Decode.andMap Decode.float
        |> Decode.andMap Decode.string
        |> Decode.andMap Decode.string


myTypeEncoder : Encoder (Maybe String)
myTypeEncoder =
    Encode.maybe Encode.string


myTypeDecoder : Decoder (Maybe String)
myTypeDecoder =
    Decode.nullable Decode.string
