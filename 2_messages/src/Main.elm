module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Json.Decode as Decode

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    , users : List User
    , newName : String
    }


type alias User =
    String


init : Model
init =
    { greetings = "Hello World"
    , users = [ "Homer", "Maggie", "Bart", "Lisa" ]
    , newName = ""
    }


type Msg
    = NoOp
    | NameInput String
    | AddUser


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

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
        [ h1 [] [ text model.greetings ]
        , input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user ]


onKeyDown : (Int -> Msg) -> Html.Attribute Msg
onKeyDown keyMsg =
    on "keypress" (Decode.map keyMsg keyCode)
