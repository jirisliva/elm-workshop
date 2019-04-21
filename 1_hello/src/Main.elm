module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    }


init : Model
init =
    { greetings = "Hello World"
    }


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.greetings ]
        ]
