module UserList exposing (Model, Msg(..), User, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (..)


type alias Model =
    { users : List User
    , newName : String
    }


type alias User =
    String


init : List String -> Model
init names =
    { users = names
    , newName = ""
    }


type Msg
    = NameInput String
    | AddUser


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameInput name ->
            { model | newName = name }

        AddUser ->
            { model
                | users = model.newName :: model.users
                , newName = ""
            }


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewName model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text name ]
