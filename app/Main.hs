module Main where

import              System.Environment
import              System.Console.GetOpt
import              Data.Text
import              System.FilePath
import              Control.Monad

import              DirectoryTools          (conditionalMoveInto, cleanDirectory, flatFilesystemTree)

data Flag = Help | SubString String | FolderName String | Root FilePath| Order | Flat | Group
    deriving (Show, Eq)

options:: [OptDescr Flag]
options = [
    Option ['h'] ["help"]           (NoArg Help)                                                   "Show this help message and exit",
    Option ['f'] ["folder-name"]    (ReqArg FolderName "FOLDER_NAME")                              "The folder name where you want to group files (to use with -G)",
    Option ['r'] ["root"]           (ReqArg Root "ROOT_FOLDER")                                    "The root folder where you want to execute the ORDER, FLAT or GROUP process",
    Option ['s'] ["substring"]      (ReqArg SubString "SUBSTRING")                                 "Define the substring that match with the files you want to group",
    Option ['O'] ["order"]          (NoArg Order)                                                  "Flag to enable the ORDER process",
    Option ['F'] ["flat"]           (NoArg Flat)                                                   "Flag to enable the FLAT process",
    Option ['G'] ["group"]          (NoArg Group)                                                  "Flag to enable the GROUP function"
    ]

help:: String
help = "Examples of Usage:\n\
        \1. TO FLAT THE FILESYSTEM TREE INTO THE ROOT FOLDER \n\ 
        \   -> sortingbot -F -r [ROOT_PATH] \n\
        \2. TO FLAT AND ORDER THE FYLESYSTEM TREE UNDER THE ROOT\n\
        \   -> sortingbot -O -r [ROOT_PATH] \n\
        \3. TO GROUP THE FILES THAT MATCH WITH THE SUBSTRING INTO A FOLDER\n\
        \   -> sortingbot -G -f [FOLDER_NAME] -r [ROOT_PATH] -s [SUBSTRING]\n\n\n\
        \OPTIONS"

type Arg = String

parseArgv:: [String] -> String -> [OptDescr Flag] -> ([Flag], [Arg])
parseArgv argv help options =
    case getOpt Permute options argv of
        (flags, args, []) -> (flags, args)
        (_, _, errs) -> error $ Prelude.concat errs ++ help


main :: IO ()
main = do
    args <- getArgs
    let (flags, argv) = parseArgv args help options
    if Help `elem` flags || Prelude.null args
        then
            putStrLn $ usageInfo help options
        else do
            putStrLn "Are you sure (Y/n)?"
            r <- getLine
            when (pack "y" == toLower  (pack r)) $ do
                    when (Order `elem` flags) (startOrdering flags)
                    when (Flat `elem` flags) (startFlatting flags)
                    when (Group `elem` flags)  (startGrouping flags)

    where

        getRoot:: [Flag] -> String
        getRoot [] = ""
        getRoot ((Root s):xs) = s
        getRoot (x:xs) = getRoot xs

        getFolderName:: [Flag] -> String
        getFolderName [] = ""
        getFolderName ((FolderName s):xs) = s
        getFolderName (x:xs) = getFolderName xs

        getSubString:: [Flag] -> String
        getSubString [] = ""
        getSubString ((SubString s):xs) = s
        getSubString (x:xs) = getSubString xs

        startOrdering:: [Flag] -> IO()
        startOrdering flags = do
            let root = getRoot flags
            putStrLn ("ORDER PROCESS STARTED IN FOLDER -> " ++ root)
            when (Prelude.null root) (error ("ERROR -> THE ROOT FOLDER NOT DEFINED\n\n" ++ help))
            unless (Prelude.null root) $ do
                    flatFilesystemTree root
                    cleanDirectory root
            putStrLn "ORDER PROCESS CLOSED"

        startFlatting:: [Flag] ->IO()
        startFlatting flags = do
             let root = getRoot flags
             putStrLn ("FLAT PROCESS STARTED IN FOLDER -> " ++ root)
             when (Prelude.null root) (error ("ERROR -> THE ROOT FOLDER NOT DEFINED\n\n" ++ help))
             unless (Prelude.null root) (flatFilesystemTree root)
             putStrLn "FLAT PROCESS CLOSED"

        startGrouping:: [Flag] ->IO()
        startGrouping flags = do
             putStrLn "GROUP PROCESS STARTED"
             let folderName = getFolderName flags
             let substring = getSubString flags
             let root = getRoot flags
             if Prelude.null root || Prelude.null substring || Prelude.null folderName
                 then error ("ERROR -> THE ARGUMENTS ARE NOT CORRECTLY DEFINED\n\n" ++ help)
                 else
                    conditionalMoveInto substring folderName root
             putStrLn "GROUP PROCESS CLOSED"


