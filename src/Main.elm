module Main exposing (main)

import Browser
import GeneratedPorts
import Html exposing (..)
import Html.Attributes exposing (href, id)
import Html.Events exposing (onClick)
import InteropDefinitions
import InteropPorts
import Json.Decode
import RelativeTimeFormat


main : Program Json.Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { draft : String
    , messages : List String
    }


init : Json.Decode.Value -> ( Model, Cmd Msg )
init flags =
    case flags |> GeneratedPorts.decodeFlags of
        Err flagsError ->
            Debug.todo <| Json.Decode.errorToString flagsError

        Ok decodedFlags ->
            ( { draft = "", messages = [] }
            , Cmd.none
            )


type Msg
    = SendAlert
    | ScrollTo String
    | RelativeFormat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendAlert ->
            ( model
            , InteropPorts.alert "Hi!!!"
            )

        ScrollTo string ->
            ( model
            , InteropPorts.scrollIntoView
                { id = string
                , options =
                    { behavior = Nothing
                    , block = Nothing
                    , inline = Nothing
                    }
                }
            )

        RelativeFormat ->
            ( model
            , InteropPorts.relativeTimeFormat
                { locale = Just RelativeTimeFormat.En
                , value = -1
                , unit = RelativeTimeFormat.Days
                , style = RelativeTimeFormat.Long
                , numeric = RelativeTimeFormat.Auto
                }
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        ([ h1 [] [ text "Echo Chat" ]
         , button [ Html.Events.onClick SendAlert ] [ text "Alert" ]
         , button [ Html.Events.onClick RelativeFormat ] [ text "Relative Format" ]
         , div [] buttons
         ]
            ++ (places
                    |> List.map image
               )
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


image : { name : String, url : String } -> Html msg
image info =
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
    places
        |> List.map ipsumButton


ipsumButton : { name : String, url : String } -> Html Msg
ipsumButton info =
    button [ onClick <| ScrollTo info.name ]
        [ text <| info.name
        ]
