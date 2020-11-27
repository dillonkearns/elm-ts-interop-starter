module Ports exposing (..)

import TsInterop.Encode as Encoder exposing (required)


type ToJs
    = SendPresenceHeartbeat
    | Alert String


toElm : Encoder.Encoder ToJs
toElm =
    Encoder.union
        (\vSendHeartbeat vAlert value ->
            case value of
                SendPresenceHeartbeat ->
                    vSendHeartbeat

                Alert string ->
                    vAlert string
        )
        |> Encoder.variant0 "SendPresenceHeartbeat"
        |> Encoder.variantObject "Alert" [ required "message" identity Encoder.string ]
        |> Encoder.buildUnion
