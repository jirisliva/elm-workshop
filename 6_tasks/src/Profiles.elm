module Profiles exposing (get)

import Http
import Json.Decode as Decode
import Rest
import Task exposing (Task)


get : Task Http.Error (List String)
get =
    Http.task
        { method = "GET"
        , headers = []
        , url = "http://localhost:3000/profiles"
        , body = Http.emptyBody
        , resolver = Rest.jsonResolver (Decode.list Decode.string)
        , timeout = Nothing
        }
