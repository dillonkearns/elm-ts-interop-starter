module InteropDefinitions exposing (ToJs(..), interop)

import Json.Decode
import Json.Encode
import RelativeTimeFormat
import ScrollIntoView
import TsInterop.Decode as Decode
import TsInterop.Encode as Encoder exposing (optional, required)


type ToJs
    = SendPresenceHeartbeat
    | Alert String
    | ScrollIntoView { id : String, options : ScrollIntoView.Options }
    | RelativeTimeFormat RelativeTimeFormat.Options


interop : { toElm : Decode.Decoder (), fromElm : Encoder.Encoder ToJs, flags : Decode.Decoder () }
interop =
    { toElm = Decode.null ()
    , fromElm = fromElm
    , flags = Decode.null ()
    }


fromElm : Encoder.Encoder ToJs
fromElm =
    Encoder.union
        (\vSendHeartbeat vAlert vScrollIntoView vRelativeTimeFormat value ->
            case value of
                SendPresenceHeartbeat ->
                    vSendHeartbeat

                Alert string ->
                    vAlert string

                ScrollIntoView record ->
                    vScrollIntoView record

                RelativeTimeFormat options ->
                    vRelativeTimeFormat options
        )
        |> Encoder.variant0 "SendPresenceHeartbeat"
        |> Encoder.variantObject "Alert" [ required "message" identity Encoder.string ]
        |> Encoder.variantObject "ScrollIntoView"
            [ required "options" .options ScrollIntoView.encoder
            , required "id" .id Encoder.string
            ]
        |> Encoder.variantObject "RelativeTimeFormat" [ required "options" identity RelativeTimeFormat.encoder ]
        |> Encoder.buildUnion
