module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Users


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
    , users : Users.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { greetings = "Hello"
      , users = Users.init
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | UsersMsg Users.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UsersMsg subMsg ->
            let
                ( usersModel, usersCmds ) =
                    Users.update subMsg model.users
            in
            ( { model | users = usersModel }
            , Cmd.map UsersMsg usersCmds
            )


view model =
    { title = "Demo"
    , body =
        [ div []
            [ h1 [] [ text model.greetings ]
            , Html.map UsersMsg (Users.view model.users)
            ]
        ]
    }
