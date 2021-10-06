module InteropDefinitions exposing (Flags, FromElm(..), ToElm, interop)

import Json.Decode as JD
import Json.Encode as JE
import RelativeTimeFormat
import ScrollIntoView
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)
import User


type FromElm
    = Alert String
    | ScrollIntoView { id : String, options : ScrollIntoView.Options }
    | RelativeTimeFormat RelativeTimeFormat.Options
    | User User.User


type alias ToElm =
    ()


type alias Flags =
    Os


interop : { toElm : Decoder ToElm, fromElm : Encoder FromElm, flags : TsDecode.Decoder Flags }
interop =
    { toElm = TsDecode.null ()
    , fromElm = fromElm
    , flags = flags
    }


fromElm : TsEncode.Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert vScrollIntoView vRelativeTimeFormat vUser value ->
            case value of
                Alert string ->
                    vAlert string

                ScrollIntoView info ->
                    vScrollIntoView info

                RelativeTimeFormat info ->
                    vRelativeTimeFormat info

                User info ->
                    vUser info
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object [ required "message" identity TsEncode.string ])
        |> TsEncode.variantTagged "scrollIntoView"
            (TsEncode.object
                [ required "options" .options ScrollIntoView.encoder
                , required "id" .id TsEncode.string
                ]
            )
        |> TsEncode.variantTagged "relativeTimeFormat"
            (TsEncode.object
                [ required "options" identity RelativeTimeFormat.encoder ]
            )
        |> TsEncode.variantTagged "user"
            (TsEncode.object
                [ required "data" identity User.encoder ]
            )
        |> TsEncode.buildUnion


type Os
    = Mac
    | Windows
    | Linux


flags : Decoder Flags
flags =
    TsDecode.field "os"
        (TsDecode.oneOf
            [ TsDecode.literal Mac (JE.string "Mac")
            , TsDecode.literal Windows (JE.string "Windows")
            ]
        )
