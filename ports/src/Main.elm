port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
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
    onColorChange OnColorChange


port setColor : String -> Cmd msg


port onColorChange : (String -> msg) -> Sub msg


type alias Model =
    { greetings : String
    , color : Maybe String
    }


type alias Flags =
    { color : Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model "Ports: Store Application state in LocalStorage" flags.color
    , Cmd.none
    )


type Msg
    = NoOp
    | SetColor String
    | OnColorChange String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SetColor color ->
            ( model, setColor color )

        OnColorChange color ->
            ( { model | color = Just color }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Demo"
    , body =
        [ div []
            [ h3 [] [ text model.greetings ]
            , viewButton model.color "Red"
            , viewButton model.color "Blue"
            , viewButton model.color "Green"
            ]
        ]
    }


viewButton : Maybe String -> String -> Html Msg
viewButton maybeCurrentColor color =
    let
        colorStyle =
            maybeCurrentColor
                |> Maybe.andThen
                    (\currentColor ->
                        if currentColor == color then
                            Just (style "background" color)

                        else
                            Nothing
                    )
                |> Maybe.withDefault (style "background" "lightgrey")
    in
    button [ onClick <| SetColor color, colorStyle ] [ text color ]
