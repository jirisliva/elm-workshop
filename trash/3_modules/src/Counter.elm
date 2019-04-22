module Counter exposing (ExternalMsg(..), Model, Msg, init, update, view)

import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    }


type Msg
    = Increase
    | Decrease


type ExternalMsg
    = Close
    | Save


init : Model
init =
    Model 0


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        Increase ->
            ( { model | counter = model.counter + 1 }, Close )

        Decrease ->
            ( { model | counter = model.counter - 1 }, Save )


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increase ] [ text " + " ]
        , button [ onClick Decrease ] [ text " - " ]
        ]
