module Main exposing (Model, Msg(..), init, main, update, view)

import Api
import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Names


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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , names = Names.init []
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | NamesMsg Names.Msg
    | GetNames
    | GetNamesResult (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NamesMsg subMsg ->
            ( { model | names = Names.update subMsg model.names }
            , Cmd.none
            )

        GetNames ->
            ( model
            , Api.getNames GetNamesResult
            )

        GetNamesResult result ->
            let
                names =
                    case result of
                        Ok fetchedNames ->
                            fetchedNames

                        Err _ ->
                            []
            in
            ( { model | names = Names.init names }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , button [onClick GetNames] [text "Load"]
            , Html.map NamesMsg (Names.view model.names)
            ]
        ]
    }
