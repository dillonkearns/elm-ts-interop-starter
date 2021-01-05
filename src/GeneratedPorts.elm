port module GeneratedPorts exposing (decodeFlags, fromJs, toJs)

import InteropDefinitions exposing (ToJs, ToElm, Flags)
import Json.Decode
import Json.Encode
import TsInterop.Decode as Decode
import TsInterop.Encode as Encode


toJs : ToJs -> Cmd msg
toJs value =
    value
        |> (InteropDefinitions.interop.fromElm |> Encode.encoder)
        |> fromElm


fromJs : Sub (Result Json.Decode.Error ToElm)
fromJs =
    (InteropDefinitions.interop.toElm |> Decode.decoder)
        |> Json.Decode.decodeValue
        |> toElm


decodeFlags : Json.Decode.Value -> Result Json.Decode.Error Flags
decodeFlags flags =
    Json.Decode.decodeValue
        (InteropDefinitions.interop.flags |> Decode.decoder)
        flags


port fromElm : Json.Encode.Value -> Cmd msg


port toElm : (Json.Decode.Value -> msg) -> Sub msg
