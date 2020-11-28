module Main exposing (main)

import Browser
import GeneratedPorts
import Html exposing (..)
import Html.Attributes exposing (href, id)
import Html.Events exposing (onClick)
import InteropDefinitions
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
    | ScrollTo Int
    | RelativeFormat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendAlert ->
            ( model
            , GeneratedPorts.toJs <| InteropDefinitions.Alert "Hi!!!"
            )

        ScrollTo number ->
            ( model
            , GeneratedPorts.toJs <|
                InteropDefinitions.ScrollIntoView
                    { id = "header-" ++ String.fromInt number
                    , options =
                        { behavior = Nothing
                        , block = Nothing
                        , inline = Nothing
                        }
                    }
            )

        RelativeFormat ->
            ( model
            , GeneratedPorts.toJs <|
                InteropDefinitions.RelativeTimeFormat
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
            ++ (List.range 1 10
                    |> List.map ipsum
                    |> List.concat
               )
        )


buttons : List (Html Msg)
buttons =
    List.range 1 10
        |> List.map ipsumButton


ipsumButton : Int -> Html Msg
ipsumButton number =
    button [ onClick <| ScrollTo number ]
        [ text <| String.fromInt number
        ]


ipsum : Int -> List (Html msg)
ipsum number =
    [ h2 [ id <| "header-" ++ String.fromInt number ]
        [ text <| "Heading " ++ String.fromInt number ]
    , p []
        [ strong []
            [ text "Pellentesque habitant morbi tristique" ]
        , text "senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. "
        , em []
            [ text "Aenean ultricies mi vitae est." ]
        , text "Mauris placerat eleifend leo. Quisque sit amet est et sapien ullamcorper pharetra. Vestibulum erat wisi, condimentum sed, "
        , code []
            [ text "commodo vitae" ]
        , text ", ornare sit amet, wisi. Aenean fermentum, elit eget tincidunt condimentum, eros ipsum rutrum orci, sagittis tempus lacus enim ac dui. "
        , a [ href "#" ]
            [ text "Donec non enim" ]
        , text "in turpis pulvinar facilisis. Ut felis."
        ]
    , h2 []
        [ text "Header Level 2" ]
    , ol []
        [ li []
            [ text "Lorem ipsum dolor sit amet, consectetuer adipiscing elit." ]
        , li []
            [ text "Aliquam tincidunt mauris eu risus." ]
        ]
    , blockquote []
        [ p []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus magna. Cras in mi at felis aliquet congue. Ut a est eget ligula molestie gravida. Curabitur massa. Donec eleifend, libero at sagittis mollis, tellus est malesuada tellus, at luctus turpis elit sit amet quam. Vivamus pretium ornare est." ]
        ]
    , h3 []
        [ text "Header Level 3" ]
    , ul []
        [ li []
            [ text "Lorem ipsum dolor sit amet, consectetuer adipiscing elit." ]
        , li []
            [ text "Aliquam tincidunt mauris eu risus." ]
        ]
    ]
