module Api exposing (getNames)

import Http
import Json.Decode as Decode


type alias NamesResult =
    Result Http.Error (List String)


getNames : (NamesResult -> msg) -> Cmd msg
getNames msg =
    Http.get
        { url = "http://localhost:3000/names"
        , expect = Http.expectJson msg (Decode.list Decode.string)
        }
