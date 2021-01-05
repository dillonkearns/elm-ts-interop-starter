module User exposing (..)

{-
   type User =
      | { kind: "admin"; id: string }
      | { kind: "guest" }
      | { kind: "regular"; name: string };
-}

import Json.Encode as JE
import TsInterop.Decode as Decode exposing (Decoder)
import TsInterop.Encode as Encode exposing (Encoder)


type User
    = Admin { id : String }
    | Guest
    | Regular { name : String, id : String }


userEncoder : Encoder User
userEncoder =
    Encode.union
        (\vAdmin vGuest vRegular value ->
            case value of
                Admin data ->
                    vAdmin data

                Guest ->
                    vGuest

                Regular data ->
                    vRegular data
        )
        |> Encode.variant
            (Encode.object
                [ Encode.required "kind" identity (Encode.literal <| JE.string "admin")
                , Encode.required "id" .id Encode.string
                ]
            )
        |> Encode.variantLiteral
            (JE.object
                [ ( "kind", JE.string "guest" )
                ]
            )
        |> Encode.variant
            (Encode.object
                [ Encode.required "kind" identity (Encode.literal <| JE.string "regular")
                , Encode.required "name" .name Encode.string
                , Encode.required "id" .id Encode.string
                ]
            )
        |> Encode.buildUnion


userDecoder : Decoder User
userDecoder =
    Decode.oneOf
        [ Decode.succeed (\() id -> Admin { id = id })
            |> Decode.andMap (Decode.field "kind" (Decode.literal () (JE.string "admin")))
            |> Decode.andMap (Decode.field "id" Decode.string)
        , Decode.literal Guest (JE.string "guest")
        , Decode.succeed (\() name id -> Regular { name = name, id = id })
            |> Decode.andMap (Decode.field "kind" (Decode.literal () (JE.string "regular")))
            |> Decode.andMap (Decode.field "name" Decode.string)
            |> Decode.andMap (Decode.field "id" Decode.string)
        ]
