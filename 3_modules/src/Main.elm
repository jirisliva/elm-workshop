module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Json.Decode as Decode
import Users


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    , users : Users.Model
    }


init : Model
init =
    { greetings = "Hello World"
    , users = Users.init
    }


type Msg
    = NoOp
    | UsersMsg Users.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UsersMsg subMsg ->
            let
                usersModel =
                    Users.update subMsg model.users
            in
            { model | users = usersModel }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.greetings ]
        , Html.map UsersMsg (Users.view model.users)
        ]
