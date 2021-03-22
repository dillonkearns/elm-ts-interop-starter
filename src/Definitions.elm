module Definitions exposing (Os(..), alert, flags, goodbye, scrollIntoView)

import Json.Encode as JE
import ScrollIntoView
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode


type alias Flags =
    { os : Maybe Os
    }


scrollIntoView =
    TsEncode.object
        [ TsEncode.required "options" .options ScrollIntoView.encoder
        , TsEncode.required "id" .id TsEncode.string
        ]


flags : Decoder Flags
flags =
    TsDecode.map Flags
        (TsDecode.field "os" osDecoder)


alert =
    TsEncode.string


osDecoder : Decoder (Maybe Os)
osDecoder =
    TsDecode.nullable
        (TsDecode.oneOf
            [ TsDecode.literal Mac (JE.string "Mac")
            , TsDecode.literal Windows (JE.string "Windows")
            , TsDecode.literal Linux (JE.string "Linux")
            ]
        )


type Os
    = Mac
    | Windows
    | Linux


goodbye =
    TsEncode.null
