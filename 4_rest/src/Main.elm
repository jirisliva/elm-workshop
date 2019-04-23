module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Users


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
    , users : Users.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , users = Users.init []
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | UsersMsg Users.Msg
    | GetUsers
    | GotUsers (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UsersMsg subMsg ->
            ( { model | users = Users.update subMsg model.users }
            , Cmd.none
            )

        GetUsers ->
            ( model, fetch )

        GotUsers result ->
            let
                users =
                    case result of
                        Ok fetchedUsers ->
                            fetchedUsers

                        Err _ ->
                            []

                -- users =
                --     result |> Result.withDefault []
            in
            ( { model | users = Users.init users }
            , Cmd.none
            )


fetch : Cmd Msg
fetch =
    Http.get
        { url = "http://localhost:3000/users"
        , expect = Http.expectJson GotUsers (Decode.list Decode.string)
        }


view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , button [ onClick GetUsers ] [ text "Load" ]
            , Html.map UsersMsg (Users.view model.users)
            ]
        ]
    }
