module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Navigation exposing (Location)
import Route


---- MODEL ----


type alias Model =
    { history : List Navigation.Location
    , currentRoute : Location
    }


init : Navigation.Location -> ( Model, Cmd msg )
init location =
    ( Model [ location ] location
    , Cmd.none
    )



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
