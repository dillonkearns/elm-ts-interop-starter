module Definitions exposing (..)

import TsJson.Decode as TsDecode
import TsJson.Encode as TsEncode


flags =
    TsDecode.bool


goodbye =
    TsEncode.null
