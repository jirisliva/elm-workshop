module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { greetings : String
    , counter : Int
    }


init : Model
init =
    Model "Hello World" 0


type Msg
    = Increase
    | Decrease


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { model | counter = model.counter + 1 }

        Decrease ->
            { model | counter = model.counter - 1 }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.greetings ]
        , h2 [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increase ] [ text " + " ]
        , button [ onClick Decrease ] [ text " - " ]
        ]
