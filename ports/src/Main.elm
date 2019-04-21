port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    onLastAccess OnLastAccess


port setProfile : String -> Cmd msg


port onLastAccess : (String -> msg) -> Sub msg


type alias Model =
    { greetings : String
    , lastAccess : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Hello World" "Unknown"
    , Cmd.none
    )


type Msg
    = NoOp
    | SetProfile
    | OnLastAccess String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SetProfile ->
            ( model, setProfile "pythagoras" )

        OnLastAccess lastAccess ->
            ( { model | lastAccess = lastAccess }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , button [ onClick SetProfile ] [ text "Set Profile" ]
            , div []
                [ span [] [ text "Last Access:" ]
                , em [] [ text model.lastAccess ]
                ]
            ]
        ]
    }
