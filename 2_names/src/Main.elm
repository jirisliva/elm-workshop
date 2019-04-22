module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Json.Decode as Decode


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    , names : List String
    , newName : String
    }


init : Model
init =
    { greetings = "Hello World"
    , names = [ "Homer", "Maggie", "Bart", "Lisa" ]
    , newName = ""
    }


type Msg
    = NoOp
    | NameInput String
    | AddName


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        NameInput name ->
            { model | newName = name }

        AddName ->
            { model
                | names = model.newName :: model.names
                , newName = ""
            }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.greetings ]
        , input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddName ] [ text "Add" ]
        , div [] (List.map viewName model.names)
        ]


viewName : String -> Html Msg
viewName name =
    Html.p [] [ text name ]


onKeyDown : (Int -> Msg) -> Html.Attribute Msg
onKeyDown keyMsg =
    on "keypress" (Decode.map keyMsg keyCode)
