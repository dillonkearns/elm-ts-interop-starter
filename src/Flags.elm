module Flags exposing (Flags, decoder, tsDecoder)

import Json.Decode as Decode exposing (Decoder)
import TsJson.Decode as TsDecode


type alias Flags =
    { width : Int
    , height : Int
    }


decoder : Decoder Flags
decoder =
    Decode.map2 Flags
        (Decode.field "width" Decode.int)
        (Decode.field "height" Decode.int)


tsDecoder : TsDecode.Decoder Flags
tsDecoder =
    TsDecode.map2 Flags
        (TsDecode.field "width" TsDecode.int)
        (TsDecode.field "height" TsDecode.int)
