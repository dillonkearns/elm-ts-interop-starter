module ScrollIntoView exposing (..)

import Json.Encode as JE
import TsJson.Encode as Encode exposing (Encoder)


encoder : Encoder ScrollIntoViewOptions
encoder =
    Encode.object
        [ Encode.optional "block"
            .block
            (Encode.union
                (\vCenter vEnd vNearest vStart value ->
                    case value of
                        Center ->
                            vCenter

                        End ->
                            vEnd

                        Nearest ->
                            vNearest

                        Start ->
                            vStart
                )
                |> Encode.variantLiteral (JE.string "center")
                |> Encode.variantLiteral (JE.string "end")
                |> Encode.variantLiteral (JE.string "nearest")
                |> Encode.variantLiteral (JE.string "start")
                |> Encode.buildUnion
            )
        , Encode.optional "inline"
            .inline
            (Encode.union
                (\vCenter vEnd vNearest vStart value ->
                    case value of
                        Center ->
                            vCenter

                        End ->
                            vEnd

                        Nearest ->
                            vNearest

                        Start ->
                            vStart
                )
                |> Encode.variantLiteral (JE.string "center")
                |> Encode.variantLiteral (JE.string "end")
                |> Encode.variantLiteral (JE.string "nearest")
                |> Encode.variantLiteral (JE.string "start")
                |> Encode.buildUnion
            )
        ]


type alias ScrollIntoViewOptions =
    { block : Maybe Position, inline : Maybe Position }


type Position
    = Center
    | End
    | Nearest
    | Start
