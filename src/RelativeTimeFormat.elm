module RelativeTimeFormat exposing (..)

{-| <https://tc39.es/ecma402/#sec-Intl.RelativeTimeFormat.prototype.format>
-}

import Json.Encode as Encode
import TsJson.Encode as Encoder exposing (Encoder, optional, required)



--BCP47LanguageTag


type Locale
    = En
    | Es


type alias Options =
    { locale : Maybe Locale
    , value : Int
    , unit : RelativeTimeFormatUnit
    , numeric : Numeric
    , style : Style
    }


type Numeric
    = Always
    | Auto


type Style
    = Long
    | Short
    | Narrow


encoder : Encoder Options
encoder =
    --(
    --            locales?: BCP47LanguageTag | BCP47LanguageTag[],
    --            options?: RelativeTimeFormatOptions,
    --        )
    Encoder.object
        [ optional "locales" .locale (Encoder.string |> Encoder.map localeToString)

        --, optional "options" .locale (Encoder.string |> Encoder.map localeToString)
        , required "value" .value Encoder.int
        , required "unit" .unit unitEncoder
        , required "style" .style styleEncoder
        ]


localeToString : Locale -> String
localeToString locale =
    case locale of
        En ->
            "en"

        Es ->
            "es"


type RelativeTimeFormatUnit
    = Years
    | Quarters
    | Months
    | Weeks
    | Days
    | Hours
    | Minutes
    | Seconds


unitToString : RelativeTimeFormatUnit -> String
unitToString unit =
    case unit of
        Years ->
            "years"

        Quarters ->
            "quarters"

        Months ->
            "months"

        Weeks ->
            "weeks"

        Days ->
            "days"

        Hours ->
            "hours"

        Minutes ->
            "minutes"

        Seconds ->
            "seconds"


unitEncoder : Encoder RelativeTimeFormatUnit
unitEncoder =
    Encoder.union
        (\vYears vQuarters vMonths vWeeks vDays vHours vMinutes vSeconds value ->
            case value of
                Years ->
                    vYears

                Quarters ->
                    vQuarters

                Months ->
                    vMonths

                Weeks ->
                    vWeeks

                Days ->
                    vDays

                Hours ->
                    vHours

                Minutes ->
                    vMinutes

                Seconds ->
                    vSeconds
        )
        |> literalString "years"
        |> literalString "quarters"
        |> literalString "months"
        |> literalString "weeks"
        |> literalString "days"
        |> literalString "hours"
        |> literalString "minutes"
        |> literalString "seconds"
        |> Encoder.buildUnion


styleEncoder : Encoder Style
styleEncoder =
    Encoder.union
        (\vLong vShort vNarrow value ->
            case value of
                Long ->
                    vLong

                Short ->
                    vShort

                Narrow ->
                    vNarrow
        )
        |> literalString "long"
        |> literalString "short"
        |> literalString "narrow"
        |> Encoder.buildUnion


literalString string pipe =
    pipe
        |> Encoder.variantLiteral (Encode.string string)
