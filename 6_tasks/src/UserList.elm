module UserList exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (..)
import User exposing (User)


type alias Model =
    { users : List User
    , newName : String
    }


init : List User -> Model
init users =
    { users = users
    , newName = ""
    }


type Msg
    = NameInput String
    | AddUser


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameInput name ->
            ( { model | newName = name }, Cmd.none )

        AddUser ->
            ( { model
                | users = createUser model.newName :: model.users
                , newName = ""
              }
            , Cmd.none
            )


createUser : String -> User
createUser name =
    { name = name
    , age = 18
    }


view : Model -> Html Msg
view model =
    div [ style "width" "50%" ]
        [ input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user.name ]
