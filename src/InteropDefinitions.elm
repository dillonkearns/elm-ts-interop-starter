module InteropDefinitions exposing (Flags, FromElm(..), ToElm(..), User, interop)

import Log
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, required)


interop :
    { toElm : Decoder ToElm
    , fromElm : Encoder FromElm
    , flags : Decoder Flags
    }
interop =
    { toElm = toElm
    , fromElm = fromElm
    , flags = flags
    }


type FromElm
    = Log { kind : Log.Kind, message : String }
    | AttemptLogIn String


type ToElm
    = AuthenticatedUser User
    | UserNotFound


type alias User =
    { username : String
    , avatarUrl : String
    }


type alias Flags =
    { dimensions : Dimensions
    }


type alias Dimensions =
    { width : Int, height : Int }


fromElm : Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert vAttemptLogIn value ->
            case value of
                Log info ->
                    vAlert info

                AttemptLogIn username ->
                    vAttemptLogIn username
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object
                [ required "message" .message TsEncode.string
                , required "kind" .kind Log.kindEncoder
                ]
            )
        |> TsEncode.variantTagged "attemptLogIn"
            (TsEncode.object
                [ required "username" identity TsEncode.string
                ]
            )
        |> TsEncode.buildUnion


toElm : Decoder ToElm
toElm =
    TsDecode.discriminatedUnion "tag"
        [ ( "authenticatedUser"
          , TsDecode.map AuthenticatedUser
                (TsDecode.map2 User
                    (TsDecode.field "username" TsDecode.string)
                    (TsDecode.field "avatarUrl" TsDecode.string)
                )
          )
        , ( "userNotFound"
          , TsDecode.succeed UserNotFound
          )
        ]


flags : Decoder Flags
flags =
    TsDecode.map Flags
        (TsDecode.field "dimensions" dimensionsDecoder)


dimensionsDecoder : Decoder Dimensions
dimensionsDecoder =
    TsDecode.succeed Dimensions
        |> TsDecode.andMap (TsDecode.field "width" TsDecode.int)
        |> TsDecode.andMap (TsDecode.field "height" TsDecode.int)
