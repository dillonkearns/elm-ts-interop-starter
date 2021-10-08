module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href, id, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit, preventDefaultOn)
import InteropDefinitions
import InteropPorts
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
    { osMessage : String
    , input : String
    }


init : JD.Value -> ( Model, Cmd Msg )
init flags =
    case InteropPorts.decodeFlags flags of
        Err flagsError ->
            Debug.todo <| JD.errorToString flagsError

        Ok decodedFlags ->
            let
                osString =
                    Debug.toString decodedFlags
            in
            ( { osMessage = "You're on " ++ osString ++ " OS."
              , input = ""
              }
            , Cmd.none
            )


type Msg
    = SendAlert
    | ScrollTo String
    | UpdateAlertText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendAlert ->
            ( model
            , InteropDefinitions.Alert model.input
                |> InteropPorts.fromElm
            )

        ScrollTo string ->
            ( model
            , InteropDefinitions.ScrollIntoView
                { id = string
                , options =
                    { behavior = Nothing
                    , block = Nothing
                    , inline = Nothing
                    }
                }
                |> InteropPorts.fromElm
            )

        UpdateAlertText newText ->
            ( { model | input = newText }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        ([ h1 [] [ text "elm-ts-interop demo" ]
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
         , div [] [ p [] [ text model.osMessage ] ]
         , div []
            (h2 [] [ text "Scroll to Photo" ]
                :: buttons
            )
         ]
            ++ (places |> List.map photo)
        )


places : List { name : String, url : String }
places =
    [ { name = "Hawaii"
      , url = "https://images.unsplash.com/photo-1598135753163-6167c1a1ad65?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=2249&q=80"
      }
    , { name = "Norway"
      , url = "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80"
      }
    , { name = "Alaska"
      , url = "https://images.unsplash.com/photo-1507939040444-21d4dca3781e?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80"
      }
    , { name = "India"
      , url = "https://images.unsplash.com/photo-1523428461295-92770e70d7ae?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1882&q=80"
      }
    ]


photo : { name : String, url : String } -> Html msg
photo info =
    div []
        [ h2 [ id info.name ] [ text info.name ]
        , img
            [ Html.Attributes.src info.url
            , Html.Attributes.style "height" "600px"
            ]
            []
        ]


buttons : List (Html Msg)
buttons =
    places |> List.map photoButton


photoButton : { name : String, url : String } -> Html Msg
photoButton info =
    button [ onClick <| ScrollTo info.name ]
        [ text <| info.name
        ]
