module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Navigation exposing (Location)
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


---- MODEL ----


type Route
    = Home
    | About


type alias Model =
    { history : List Navigation.Location
    , currentRoute : Location
    }


init : Navigation.Location -> ( Model, Cmd msg )
init location =
    ( Model [ location ] location
    , Cmd.none
    )


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



---- UPDATE ----


type Msg
    = NoOp
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html msg
view model =
    div []
        [ h1 [] [ text "Pages" ]
        , ul [] (List.map viewLink [ "bears", "cats", "dogs", "elephants", "fish" ])
        , h1 [] [ text "History" ]
        , ul [] (List.map viewLocation model.history)
        ]


viewLink : String -> Html msg
viewLink name =
    li [] [ a [ Attr.href ("#" ++ name) ] [ text name ] ]


viewLocation : Navigation.Location -> Html msg
viewLocation location =
    li [] [ text (location.pathname ++ location.hash) ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program
        UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
