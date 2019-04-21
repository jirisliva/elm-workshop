module Colors exposing (Color, get)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import Rest
import Task exposing (Task)


type alias Color =
    { id : Int
    , name : String
    , code : String
    }


type alias ColorResult =
    Result Http.Error (List Color)


get : Task Http.Error (List Color)
get =
    Http.task
        { method = "GET"
        , headers = []
        , url = "http://localhost:3000/colors"
        , body = Http.emptyBody
        , resolver = Rest.jsonResolver (Decode.list colorDecoder)
        , timeout = Nothing
        }


colorDecoder : Decode.Decoder Color
colorDecoder =
    Decode.succeed Color
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "code" Decode.string
