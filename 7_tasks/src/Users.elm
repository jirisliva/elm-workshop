module Users exposing (Model, Msg(..), fetch, init, update, view)

import Browser
import Colors exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Rest
import Task exposing (Task)


type alias Model =
    { users : List User
    , colors : List Color
    , newName : String
    }


type alias User =
    { name : String
    , age : Int
    }


type alias FetchedData =
    { users : List User
    , colors : List Color
    }


init : Model
init =
    { users = []
    , colors = []
    , newName = ""
    }


type Msg
    = NameInput String
    | AddUser
    | GetUsers
    | GotUsers (Result Http.Error FetchedData)


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
            ( model
            , Task.map2 FetchedData
                fetch
                Colors.fetch
                |> Task.attempt GotUsers
            )

        GotUsers result ->
            case result of
                Ok fetchedData ->
                    ( { model
                        | users = fetchedData.users
                        , colors = fetchedData.colors
                      }
                    , Cmd.none
                    )

                Err error ->
                    let
                        _ =
                            Debug.log "Fetch users failed" error
                    in
                    ( model, Cmd.none )


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
        , div [] ( List.map viewColor model.colors )
        ]


viewColor : Color -> Html Msg
viewColor color =
    Html.p [] [ text color.name ]


viewUser : User -> Html Msg
viewUser user =
    Html.p [] [ text user.name ]


fetch : Task Http.Error (List User)
fetch =
    Http.task
        { method = "GET"
        , headers = []
        , url = "http://localhost:3000/users"
        , body = Http.emptyBody
        , resolver = Rest.jsonResolver (Decode.list userDecoder)
        , timeout = Nothing
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
