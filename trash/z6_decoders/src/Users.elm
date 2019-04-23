module Users exposing (Model, Msg(..), fetch, init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)


type alias Model =
    { users : List User
    , newName : String
    }


type alias User =
    { name : String
    , age : Int
    }


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
                | users = createUser model.newName :: model.users
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

                        Err error ->
                            let
                                _ =
                                    Debug.log "Fetch users failed" error
                            in
                            []

                -- users =
                --     result |> Result.withDefault []
            in
            ( { model | users = users }
            , Cmd.none
            )


createUser : String -> User
createUser name =
    { name = name
    , age = 18
    }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetUsers ] [ text "Load" ]
        , input [ onInput NameInput, value model.newName ] []
        , button [ onClick AddUser ] [ text "Add" ]
        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user.name ]


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
