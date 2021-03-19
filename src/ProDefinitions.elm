module ProDefinitions exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import RelativeTimeFormat
import ScrollIntoView
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)
import User


type Os
    = Mac
    | Windows
    | Linux


flags : Decoder Os
flags =
    TsDecode.field "os"
        (TsDecode.oneOf
            [ TsDecode.literal Mac (JE.string "Mac")
            , TsDecode.literal Windows (JE.string "Windows")
            ]
        )


alert : Encoder String
alert =
    TsEncode.object [ required "message" identity TsEncode.string ]


scrollIntoView : Encoder { id : String, options : { behavior : Maybe ScrollIntoView.Behavior, block : Maybe ScrollIntoView.Alignment, inline : Maybe ScrollIntoView.Alignment } }
scrollIntoView =
    TsEncode.object
        [ required "options" .options ScrollIntoView.encoder
        , required "id" .id TsEncode.string
        ]


relativeTimeFormat : Encoder RelativeTimeFormat.Options
relativeTimeFormat =
    TsEncode.object [ required "options" identity RelativeTimeFormat.encoder ]


user : Encoder User.User
user =
    TsEncode.object [ required "data" identity User.encoder ]
