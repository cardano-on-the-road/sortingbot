module Logger where

import              Data.Time               
import              Types                   ( Flag(..), SortingBotState(..), SortingBotOutput(..) )

logMessage:: String -> IO()
logMessage s = do
    time <- getCurrentTime
    appendFile "log.txt"  (show time ++ " - " ++ s ++ "\n")

logBotState:: SortingBotState -> IO()
logBotState Idle = print ""
logBotState (ThreadRunning time flag) = print ""
logBotState (ThreadEnding time output) = print ""

