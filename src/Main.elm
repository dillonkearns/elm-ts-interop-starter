module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (href, id, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit, preventDefaultOn)
import InteropDefinitions
import InteropPorts
import Json.Decode as Decode
import Log
import TsJson.Decode


main : Program Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = LogMessage Log.Kind
    | OnInput String
    | ToElm (Result Decode.Error InteropDefinitions.ToElm)
    | OnUsernameInput String
    | LogIn


type alias Model =
    { input : String
    , usernameInput : String
    , flags : Result String InteropDefinitions.Flags
    , user : Maybe InteropDefinitions.User
    , subscriptionErrors : List String
    }


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    ( { input = ""
      , usernameInput = ""
      , flags =
            InteropPorts.decodeFlags flags
                |> Result.mapError Decode.errorToString
      , user = Nothing
      , subscriptionErrors = []
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogMessage kind ->
            ( model
            , InteropPorts.fromElm
                (InteropDefinitions.Log
                    { kind = kind
                    , message = model.input
                    }
                )
            )

        OnInput newText ->
            ( { model | input = newText }, Cmd.none )

        OnUsernameInput newText ->
            ( { model | usernameInput = newText }, Cmd.none )

        ToElm toElm ->
            case toElm of
                Err error ->
                    ( { model
                        | subscriptionErrors =
                            Decode.errorToString error
                                :: model.subscriptionErrors
                      }
                    , Cmd.none
                    )

                Ok okToElm ->
                    case okToElm of
                        InteropDefinitions.AuthenticatedUser user ->
                            ( { model | user = Just user }, Cmd.none )

                        InteropDefinitions.UserNotFound ->
                            ( { model | user = Nothing }, Cmd.none )

        LogIn ->
            ( model, InteropPorts.fromElm (InteropDefinitions.AttemptLogIn model.usernameInput) )


subscriptions : Model -> Sub Msg
subscriptions _ =
    InteropPorts.toElm |> Sub.map ToElm


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "elm-ts-interop demo" ]
        , div []
            [ label []
                [ text "Message: "
                , input
                    [ value model.input
                    , type_ "text"
                    , onInput OnInput
                    ]
                    []
                ]
            , button
                [ onClick (LogMessage Log.Info)
                ]
                [ text "Log ℹ️" ]
            , button
                [ onClick (LogMessage Log.Warning)
                ]
                [ text "Log ️⚠️" ]
            , button
                [ onClick (LogMessage Log.Error)
                ]
                [ text "Log ️❌️" ]
            , button
                [ onClick (LogMessage Log.Alert)
                ]
                [ text "Alert 🚨" ]
            ]
        , logInView model
        , avatarView model
        , flagsView model.flags
        , subErrorsView model.subscriptionErrors
        ]


avatarView : Model -> Html msg
avatarView model =
    div []
        [ h2 []
            [ model.user
                |> Maybe.map .username
                |> Maybe.withDefault "User Not Found"
                |> text
            ]
        , case model.user of
            Just user ->
                img [ Attr.src user.avatarUrl, Attr.width 100 ] []

            Nothing ->
                text "User not found"
        ]


logInView : Model -> Html Msg
logInView model =
    form
        [ onSubmit LogIn
        ]
        [ label []
            [ text "Username: "
            , input
                [ value model.usernameInput
                , type_ "text"
                , onInput OnUsernameInput
                ]
                []
            ]
        , button
            []
            [ text "Log in" ]
        ]


flagsView : Result String InteropDefinitions.Flags -> Html msg
flagsView result =
    div []
        [ h1 [] [ text "Flags" ]
        , case result of
            Ok okFlags ->
                pre
                    [ Attr.style "border" "solid 8px green"
                    , Attr.style "padding" "30px"
                    ]
                    [ text <| Debug.toString okFlags
                    ]

            Err flagsError ->
                pre
                    [ Attr.style "border" "solid 8px tomato"
                    , Attr.style "padding" "30px"
                    ]
                    [ text flagsError
                    ]
        ]


subErrorsView : List String -> Html msg
subErrorsView errors =
    if errors == [] then
        div [] []

    else
        div []
            [ h1 [] [ text "Sub Errors" ]
            , div [] (errors |> List.map errorView)
            ]


errorView : String -> Html msg
errorView message =
    pre
        [ Attr.style "border" "solid 8px tomato"
        , Attr.style "padding" "30px"
        ]
        [ text message
        ]
