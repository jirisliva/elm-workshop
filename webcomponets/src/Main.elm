port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode


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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "WebComponents Demo"
    , Cmd.none
    )


type Msg
    = NoOp
    | EditorChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        EditorChanged newValue ->
            ( { model | greetings = newValue }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ h3 [] [ text model.greetings ]
        , node "custom-editor"
            [ property "editorValue" (Encode.string model.greetings)
            , on "editorChanged" editorChangedDecoder
            ]
            []
        ]
    }


editorChangedDecoder : Decode.Decoder Msg
editorChangedDecoder =
    Decode.map EditorChanged <| Decode.at [ "detail" ] <| Decode.string
