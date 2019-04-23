module Main exposing (main)

import Browser
import Html exposing (..)
import UserList


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    , users : UserList.Model
    }


init : Model
init =
    { greetings = "Hello World"
    , users = UserList.init
    }


type Msg
    = NoOp
    | UserListMsg UserList.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UserListMsg subMsg ->
            let
                userListModel =
                    UserList.update subMsg model.users
            in
            { model | users = userListModel }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.greetings ]
        , Html.map UserListMsg (UserList.view model.users)
        ]
