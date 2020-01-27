module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Task
import User exposing (User)
import UserList


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type alias Model =
    { greetings : String
    , users : UserList.Model
    , colors : List Color
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , users = UserList.init []
      , colors = []
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | UsersMsg UserList.Msg
    | FetchData
    | FetchDataResult (Result Http.Error FetchedData)


type alias FetchedData =
    { users : List User
    , colors : List Color
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UsersMsg subMsg ->
            let
                ( usersModel, usersCmds ) =
                    UserList.update subMsg model.users
            in
            ( { model | users = usersModel }
            , Cmd.map UsersMsg usersCmds
            )

        FetchData ->
            ( model
            , Task.map2 FetchedData
                User.fetch
                Color.fetch
                |> Task.attempt FetchDataResult
            )

        FetchDataResult result ->
            case result of
                Ok fetchedData ->
                    ( { model
                        | users = UserList.init fetchedData.users
                        , colors = fetchedData.colors
                      }
                    , Cmd.none
                    )

                Err error ->
                    let
                        _ =
                            Debug.log "Fetch users failed" error
                    in
                    ( model, Cmd.none )


view model =
    { title = "Demo"
    , body =
        [ div [ style "padding" "20px"]
            [ h1 [] [ text model.greetings ]
            , button [ onClick FetchData ] [ text "Load Data" ]
            , div [ style "display" "flex" , style "width" "60%"]
                [ Html.map UsersMsg (UserList.view model.users)
                , viewColors model.colors
                ]
            ]
        ]
    }


viewColors : List Color -> Html Msg
viewColors colors =
    div [ style "width" "50%" ] (List.map viewColor colors)


viewColor : Color -> Html Msg
viewColor color =
    Html.p [ style "background" "silver", style "padding" "5px" ] [ text color.name ]
