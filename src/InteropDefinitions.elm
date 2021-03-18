module InteropDefinitions exposing (Flags, ToElm, ToJs(..), interop)

import Json.Decode as JD
import Json.Encode as JE
import RelativeTimeFormat
import ScrollIntoView
import TsJson.Decode as Decode exposing (Decoder)
import TsJson.Encode as Encoder exposing (Encoder, optional, required)
import User


type ToJs
    = SendPresenceHeartbeat
    | Alert String
    | ScrollIntoView { id : String, options : ScrollIntoView.Options }
    | RelativeTimeFormat RelativeTimeFormat.Options
    | User User.User


type alias ToElm =
    ()


type alias Flags =
    ()


interop : { toElm : Decoder ToElm, fromElm : Encoder ToJs, flags : Decode.Decoder Flags }
interop =
    { toElm = Decode.null ()
    , fromElm = fromElm
    , flags = Decode.null ()
    }


fromElm : Encoder.Encoder ToJs
fromElm =
    Encoder.union
        (\vSendHeartbeat vAlert vScrollIntoView vRelativeTimeFormat vUser value ->
            case value of
                SendPresenceHeartbeat ->
                    vSendHeartbeat

                Alert string ->
                    vAlert string

                ScrollIntoView record ->
                    vScrollIntoView record

                RelativeTimeFormat options ->
                    vRelativeTimeFormat options

                User user ->
                    vUser user
        )
        |> Encoder.variant0 "SendPresenceHeartbeat"
        |> Encoder.variantObject "Alert" [ required "message" identity Encoder.string ]
        |> Encoder.variantObject "ScrollIntoView"
            [ required "options" .options ScrollIntoView.encoder
            , required "id" .id Encoder.string
            ]
        |> Encoder.variantObject "RelativeTimeFormat" [ required "options" identity RelativeTimeFormat.encoder ]
        |> Encoder.variantObject "User" [ required "data" identity User.encoder ]
        |> Encoder.buildUnion
