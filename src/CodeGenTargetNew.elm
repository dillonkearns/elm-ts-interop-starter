port module CodeGenTargetNew exposing (..)

import GoalPorts
import GoalPortsFromTs
import Json.Encode as Encode
import ScrollIntoView
import TsInterop.Decode as Decode
import TsInterop.Encode as Encoder


topLevel :
    { fromElm : Encoder.Encoder value
    , toElm : Decode.Decoder ()
    , flags : Decode.Decoder ()
    }
topLevel =
    { fromElm = Encoder.null
    , toElm = Decode.null ()
    , flags = Decode.null ()
    }


allTypeDefs : { fromElm : String, toElm : String, flags : String }
allTypeDefs =
    { fromElm = topLevel.fromElm |> Encoder.typeDef
    , toElm = topLevel.toElm |> Decode.tsTypeToString
    , flags = topLevel.flags |> Decode.tsTypeToString
    }


type Severity
    = Info
    | Warning
    | Error


port fromElm : Encode.Value -> Cmd msg


port log :
    { fromElm : String
    , toElm : String
    , flags : String
    }
    -> Cmd msg


main : Program () () ()
main =
    Platform.worker
        { init =
            \() ->
                ( ()
                , log allTypeDefs
                )
        , update = \msg model -> ( model, Cmd.none )
        , subscriptions = \() -> Sub.none
        }
