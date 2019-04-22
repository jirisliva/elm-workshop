module Colors exposing (Color, get)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)


type alias Color =
    { id : Int
    , name : String
    , code : String
    }


type alias ColorResult =
    Result Http.Error (List Color)


get : (ColorResult -> msg) -> Cmd msg
get msg =
    Http.get
        { url = "http://localhost:3000/colors"
        , expect = Http.expectJson msg (Decode.list colorDecoder)
        }


colorDecoder : Decode.Decoder Color
colorDecoder =
    Decode.succeed Color
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "code" Decode.string
