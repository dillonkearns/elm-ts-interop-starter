module InteropDefinitions exposing (Flags, FromElm(..), ToElm(..), interop)

import Flags
import Json.Encode
import Log
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)


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
    = Alert
        { message : String
        , kind : Log.Kind
        }
    | AttemptLogIn { username : String }


type ToElm
    = AuthenticatedUser User


type alias User =
    { username : String
    , avatarUrl : String
    }


type alias Flags =
    Flags.Flags


fromElm : Encoder FromElm
fromElm =
    TsEncode.union
        (\vAlert vAttemptLogIn value ->
            case value of
                Alert string ->
                    vAlert string

                AttemptLogIn record ->
                    vAttemptLogIn record
        )
        |> TsEncode.variantTagged "alert"
            (TsEncode.object
                [ required "message" (\value -> value.message) TsEncode.string
                , required "logKind" (\value -> value.kind) Log.encoder
                ]
            )
        |> TsEncode.variantTagged "attemptLogIn"
            (TsEncode.object
                [ required "username" (\value -> value.username) TsEncode.string
                ]
            )
        |> TsEncode.buildUnion


toElm : Decoder ToElm
toElm =
    TsDecode.discriminatedUnion "tag"
        [ ( "authenticatedUser"
          , TsDecode.map AuthenticatedUser
                (TsDecode.field "user"
                    (TsDecode.map2 User
                        (TsDecode.field "username" TsDecode.string)
                        (TsDecode.field "avatarUrl" TsDecode.string)
                    )
                )
          )
        ]


flags : Decoder Flags
flags =
    Flags.tsDecoder
