module ProDefinitions exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import RelativeTimeFormat
import ScrollIntoView
import TsJson.Decode as Decode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)
import User


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
