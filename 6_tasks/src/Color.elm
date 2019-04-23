module Color exposing (Color, fetch)

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


fetch : Task Http.Error (List Color)
fetch =
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
