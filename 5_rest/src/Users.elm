module Users exposing (Model, Msg(..), fetch, init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


type alias Model =
    { users : List User
    , newName : String
    }


type alias User =
    String


init : Model
init =
    { users = []
    , newName = ""
    }


type Msg
    = NameInput String
    | AddUser
    | GetUsers
    | GotUsers (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameInput name ->
            ( { model | newName = name }, Cmd.none )

        AddUser ->
            ( { model
                | users = model.newName :: model.users
                , newName = ""
              }
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

                        Err _ ->
                            []

                -- users =
                --     result |> Result.withDefault []
            in
            ( { model | users = users }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetUsers ] [ text "Load" ]
        , input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewName model.users)
        ]


viewName : User -> Html Msg
viewName name =
    Html.p [] [ text name ]


fetch : Cmd Msg
fetch =
    Http.get
        { url = "http://localhost:3000/users"
        , expect = Http.expectJson GotUsers (Decode.list Decode.string)
        }
