module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Colors exposing (Color)
import Counter
import Html exposing (..)
import Html.Events exposing (onClick)
import Http


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
    , counter : Counter.Model
    , colors : List Color
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Hello World" Counter.init []
    , Cmd.none
    )


type Msg
    = NoOp
    | CounterMsg Counter.Msg
    | GetColors
    | GetColorsResult (Result Http.Error (List Color))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CounterMsg subMsg ->
            ( { model | counter = Counter.update subMsg model.counter }
            , Cmd.none
            )

        GetColors ->
            ( model
            , Colors.get GetColorsResult
            )

        GetColorsResult result ->
            let
                colors =
                    case result of
                        Ok fetchedColors ->
                            fetchedColors

                        Err _ ->
                            []
            in
            ( { model | colors = colors }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , Html.map CounterMsg (Counter.view model.counter)
            , button [ onClick GetColors ] [ text "Get Colors" ]
            , viewColors model.colors
            ]
        ]
    }


viewColors : List Color -> Html Msg
viewColors colors =
    table [] (List.map viewColor colors)


viewColor : Color -> Html Msg
viewColor color =
    tr []
        [ td [] [ text color ]
        ]
