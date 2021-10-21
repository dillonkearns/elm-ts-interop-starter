module Flags exposing (Flags, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Flags =
    { width : Int
    , height : Int
    }


decoder : Decoder Flags
decoder =
    Decode.map2 Flags
        (Decode.field "width" Decode.int)
        (Decode.field "height" Decode.int)
