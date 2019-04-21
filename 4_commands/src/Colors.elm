module Colors exposing (Color, get)

import Http
import Json.Decode as Decode


type alias Color =
    String


type alias ColorResult =
    Result Http.Error (List Color)


get : (ColorResult -> msg) -> Cmd msg
get msg =
    Http.get
        { url = "http://localhost:3000/colors"
        , expect = Http.expectJson msg (Decode.list Decode.string)
        }
