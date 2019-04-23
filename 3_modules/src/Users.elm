module Users exposing (Model, Msg(..), init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Json.Decode as Decode


type alias Model =
    { users : List User
    , newName : String
    }


type alias User =
    String


init : Model
init =
    { users = [ "Homer", "Maggie", "Bart", "Lisa" ]
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
        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user ]
