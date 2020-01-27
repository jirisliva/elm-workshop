module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import UserList exposing (User)


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
    , users : UserList.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , users = UserList.init []
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | UsersMsg UserList.Msg
    | GetUsers
    | GotUsers (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UsersMsg subMsg ->
            ( { model | users = UserList.update subMsg model.users }
            , Cmd.none
            )

        GetUsers ->
            ( model, fetch )

        GotUsers result ->
            let
                users =
                    case result of
                        Ok fetchedUsers ->
                            fetchedUsers

                        Err error ->
                            let
                                _ =
                                    Debug.log "Users fetch failed" error
                            in
                            []
            in
            ( { model | users = UserList.init users }
            , Cmd.none
            )


fetch : Cmd Msg
fetch =
    Http.get
        { url = "http://localhost:3000/users"
        , expect = Http.expectJson GotUsers (Decode.list userDecoder)
        }


userDecoder : Decode.Decoder User
userDecoder =
    Decode.map2 User
        (Decode.field "name" Decode.string)
        (Decode.field "age" Decode.int)


userDecoder2 : Decode.Decoder User
userDecoder2 =
    Decode.succeed User
        |> required "name" Decode.string
        |> required "age" Decode.int


view model =
    { title = "Demo"
    , body =
        [ div [style "padding" "10px" ]
            [ h1 [] [ text model.greetings ]
            , button [ onClick GetUsers ] [ text "Load" ]
            , Html.map UsersMsg (UserList.view model.users)
            ]
        ]
    }
