module Types where 

import Data.Time (UTCTime)

data Flag = Help | SubString String | FolderName String | Root FilePath| Order | Flat | Group
    deriving (Show, Eq)

data SortingBotOutput = Ok | Error String
    deriving (Show, Eq)

data SortingBotState = Idle | ThreadRunning UTCTime Flag | ThreadEnding UTCTime SortingBotOutput
    deriving (Show, Eq)



