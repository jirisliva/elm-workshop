module UserList exposing (Model, Msg(..), User, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)


type alias Model =
    { users : List User
    , newName : String
    }


type alias User =
    { name : String
    , age : Int
    }


init : List User -> Model
init users =
    { users = users
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
                | users = createUser model.newName :: model.users
                , newName = ""
            }


createUser : String -> User
createUser name =
    { name = name
    , age = 18
    }


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user.name ]
