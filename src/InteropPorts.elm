port module InteropPorts exposing (decodeFlags, fromElm, toElm)

import InteropDefinitions
import Json.Decode
import Json.Encode
import TsJson.Decode as TsDecode
import TsJson.Encode as TsEncode


fromElm : InteropDefinitions.FromElm -> Cmd msg
fromElm value =
    value
        |> (InteropDefinitions.interop.fromElm |> TsEncode.encoder)
        |> interopFromElm


toElm : Sub (Result Json.Decode.Error InteropDefinitions.ToElm)
toElm =
    (InteropDefinitions.interop.toElm |> TsDecode.decoder)
        |> Json.Decode.decodeValue
        |> interopToElm


decodeFlags : Json.Decode.Value -> Result Json.Decode.Error InteropDefinitions.Flags
decodeFlags flags =
    Json.Decode.decodeValue
        (InteropDefinitions.interop.flags |> TsDecode.decoder)
        flags


port interopFromElm : Json.Encode.Value -> Cmd msg


port interopToElm : (Json.Decode.Value -> msg) -> Sub msg
