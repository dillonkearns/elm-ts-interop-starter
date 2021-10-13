module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href, id, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit, preventDefaultOn)
import Json.Decode as JD
import TsJson.Decode


main : Program JD.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { input : String
    }


init : JD.Value -> ( Model, Cmd Msg )
init flags =
    ( { input = ""
      }
    , Cmd.none
    )


type Msg
    = SendAlert
    | UpdateAlertText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendAlert ->
            ( model
              -- TODO Alert here
            , Cmd.none
            )

        UpdateAlertText newText ->
            ( { model | input = newText }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "elm-ts-interop demo" ]
        , div []
            [ form
                [ onSubmit SendAlert
                ]
                [ label []
                    [ text "Message: "
                    , input
                        [ value model.input
                        , type_ "text"
                        , onInput UpdateAlertText
                        ]
                        []
                    ]
                , button
                    [ type_ "submit"
                    ]
                    [ text "Alert" ]
                ]
            ]
        ]
