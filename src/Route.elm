module Route exposing (Route(..), fromLocation, href, newUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import UrlParser as Url
    exposing
        ( (</>)
        , Parser
        , oneOf
        , parseHash
        , s
        , string
        , top
        )
import Navigation exposing (Location)


type Route
    = Home
    | About


router : Parser (Route -> a) a
router =
    oneOf
        [ Url.map Home top
        , Url.map About (Url.s "about")
        ]


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash router location


routeToString : Route -> String
routeToString route =
    let
        pieces =
            case route of
                Home ->
                    []

                About ->
                    [ "about" ]
    in
        "#/" ++ String.join "/" pieces


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


newUrl : Route -> Cmd msg
newUrl route =
    Navigation.newUrl (routeToString route)
