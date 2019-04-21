module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Colors exposing (Color)
import Counter
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Profiles
import Task exposing (Task)


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
    , profiles : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Hello World" Counter.init [] []
    , Cmd.none
    )


type Msg
    = NoOp
    | CounterMsg Counter.Msg
    | Fetch
    | FetchResult (Result Http.Error FetchedData)


type alias FetchedData =
    { colors : List Color
    , profiles : List String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CounterMsg subMsg ->
            ( { model | counter = Counter.update subMsg model.counter }
            , Cmd.none
            )

        Fetch ->
            ( model
            , Task.map2 FetchedData
                Colors.get
                Profiles.get
                |> Task.attempt FetchResult
            )

        FetchResult result ->
            let
                ( colors, profiles ) =
                    case result of
                        Ok data ->
                            ( data.colors, data.profiles )

                        Err _ ->
                            ( [], [] )
            in
            ( { model
                | colors = colors
                , profiles = profiles
              }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , Html.map CounterMsg (Counter.view model.counter)
            , button [ onClick Fetch ] [ text "Fetch Data" ]
            , viewColors model.colors
            , viewProfile model.profiles
            ]
        ]
    }


viewColors : List Color -> Html Msg
viewColors colors =
    table [] (List.map viewColor colors)


viewProfile : List String -> Html Msg
viewProfile profiles =
    div []
        (profiles
            |> List.map
                (\profile ->
                    div [] [ text profile ]
                )
        )


viewColor : Color -> Html Msg
viewColor color =
    tr []
        [ td [] [ text (String.fromInt color.id) ]
        , td [] [ text color.name ]
        , td [] [ text color.code ]
        ]
