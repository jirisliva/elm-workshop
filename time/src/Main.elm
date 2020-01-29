module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Names
import Task
import Time exposing (Month(..))


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type alias Model =
    { greetings : String
    , names : Names.Model
    , time : Maybe Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , names = Names.init []
      , time = Nothing
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | NamesMsg Names.Msg
    | GetTime
    | CurrentTime Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NamesMsg subMsg ->
            ( { model | names = Names.update subMsg model.names }
            , Cmd.none
            )

        GetTime ->
            ( model, Time.now |> Task.perform CurrentTime )

        CurrentTime time ->
            ( { model | time = Just time }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , button [ onClick GetTime ] [ text "Get Time" ]
            , viewTime model.time
            , Html.map NamesMsg (Names.view model.names)
            ]
        ]
    }


viewTime : Maybe Time.Posix -> Html Msg
viewTime maybeTime =
    case maybeTime of
        Just time ->
            div [] [ text (timeToString time) ]

        Nothing ->
            text ""


timeToString : Time.Posix -> String
timeToString time =
    monthToString (Time.toMonth Time.utc time)
        ++ " "
        ++ String.fromInt (Time.toDay Time.utc time)
        ++ " "
        ++ String.fromInt (Time.toYear Time.utc time)


monthToString : Time.Month -> String
monthToString month =
    case month of
        Jan ->
            "Januar"

        Feb ->
            "Februar"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"
