port module CodeGenTarget exposing (..)

import InteropDefinitions
import Json.Encode as Encode
import TsInterop.Decode as Decode
import TsInterop.Encode as Encoder


allTypeDefs : { fromElm : String, toElm : String, flags : String }
allTypeDefs =
    { fromElm = InteropDefinitions.interop.fromElm |> Encoder.typeDef
    , toElm = InteropDefinitions.interop.toElm |> Decode.tsTypeToString
    , flags = InteropDefinitions.interop.flags |> Decode.tsTypeToString
    }


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
