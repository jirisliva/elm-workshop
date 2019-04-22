module Names exposing (Model, Msg(..), init, update, view, viewName)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Json.Decode as Decode


type alias Model =
    { names : List String
    , newName : String
    }


init : Model
init =
    { names = [ "Homer", "Maggie", "Bart", "Lisa" ]
    , newName = ""
    }


type Msg
    = NameInput String
    | AddName


update : Msg -> Model -> Model
update msg model =
    case msg of
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
        [ input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddName ] [ text "Add" ]
        , div [] (List.map viewName model.names)
        ]


viewName : String -> Html Msg
viewName name =
    Html.p [] [ text name ]
