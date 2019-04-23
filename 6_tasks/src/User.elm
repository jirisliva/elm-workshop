module User exposing (User, fetch)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Rest
import Task exposing (Task)


type alias User =
    { name : String
    , age : Int
    }


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
