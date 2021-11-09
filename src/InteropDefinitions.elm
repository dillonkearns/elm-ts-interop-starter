module InteropDefinitions exposing (Flags, User, alert, attemptLogIn, authenticatedUser, flags)

import Flags
import Json.Encode
import Log
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder, optional, required)


type alias User =
    { username : String
    , avatarUrl : String
    }


type alias Flags =
    Flags.Flags


alert =
    TsEncode.object
        [ required "message" (\value -> value.message) TsEncode.string
        , required "logKind" (\value -> value.kind) Log.encoder
        ]


attemptLogIn =
    TsEncode.object
        [ required "username" (\value -> value.username) TsEncode.string
        ]


authenticatedUser =
    TsDecode.field "user"
        (TsDecode.map2 User
            (TsDecode.field "username" TsDecode.string)
            (TsDecode.field "avatarUrl" TsDecode.string)
        )


flags : Decoder Flags
flags =
    Flags.tsDecoder
