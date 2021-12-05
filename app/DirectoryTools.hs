module DirectoryTools where

-- doesFileExist
-- doesDirectoryExist
-- getDirectoryContents
-- removeDirectory
-- removeFile
-- copyFile
-- takeFileName
-- takeBaseName
-- "/Users/valeriomellini/Downloads/video/test"
-- createDirectory
-- takeExtension

import              System.Directory
import              System.Directory.Tree
import              System.FilePath                 ((</>))
import              Data.List                       (filter)
import              Data.Text
import              System.FilePath.Posix
import              Control.Monad


getAllContents:: FilePath -> IO[FilePath]
getAllContents fp = do
    c <- listDirectory fp
    let mc = fmap (\s -> fp ++ "/" ++s) c
    return mc

moveFile:: FilePath -> FilePath -> FilePath -> IO()
moveFile fileSrc src dst =
    when (src /= dst) $ do
        let fileName = takeFileName fileSrc
            fileDst = dst ++ "/" ++ fileName
        print ("MOVE " ++ fileName ++ " INTO ROOT " ++ dst)
        copyFile fileSrc fileDst
        removeFile fileSrc

moveIntoDirectory :: FilePath -> FilePath -> IO()
moveIntoDirectory fileSrc dst = do
    print ("MOVE FILE -> " ++ fileSrc ++ " - INTO DIRECTORY -> " ++ dst)
    isDir <- doesDirectoryExist dst
    let fileName = takeFileName fileSrc
    if isDir
        then move fileSrc (dst ++ "/" ++ fileName)
    else do
        createDirectory dst
        move fileSrc (dst ++ "/" ++fileName)
    where
        move:: FilePath -> FilePath -> IO()
        move src dst = do
            copyFile src dst
            removeFile src

flatFilesystemTree':: FilePath -> FilePath -> [FilePath] -> IO()
flatFilesystemTree' root node [] = return ()
flatFilesystemTree' root node (x:xs) = do
    isFile <- doesFileExist x
    isDir <- doesDirectoryExist x
    if isFile
        then  do
            --print (x ++ " IS A FILE") 
            moveFile x node root
            flatFilesystemTree' root node xs
        else do
            if isDir
                then do
                    --print (x ++ " IS A DIRECTORY") 
                    c <- getAllContents x
                    flatFilesystemTree' root x c
                    flatFilesystemTree' root node xs
                    removePathForcibly x
                else
                    flatFilesystemTree' root node xs


flatFilesystemTree:: FilePath -> IO()
flatFilesystemTree root = do
    c <- getAllContents root
    flatFilesystemTree' root root c

cleanDirectory' :: [FilePath] -> FilePath -> IO()
cleanDirectory' [] _ = return ()
cleanDirectory' (x:xs) root
    | takeExtension' x == ".jpg" ||  takeExtension' x == ".jpeg"  || takeExtension' x == ".png"   || takeExtension' x == ".ico"  || takeExtension' x == ".svg"                                      = toFolder "IMG"
    | takeExtension' x == ".torrent"                                                                                                                                                                 = toFolder "TORRENT"
    | takeExtension' x == ".mp4"  ||  takeExtension' x == ".mkv"  ||  takeExtension' x == ".mov" ||  takeExtension' x == ".flv" ||  takeExtension' x == ".avi" ||  takeExtension' x == ".srt"       = toFolder "MOV"
    | takeExtension' x == ".pdf"  ||  takeExtension' x == ".docx" ||  takeExtension' x == ".doc" ||  takeExtension' x == ".txt" ||  takeExtension' x == ".rtf" ||  takeExtension' x == ".pages"     = toFolder "DOCS"
    | takeExtension' x == ".xlsx" ||  takeExtension' x == ".xlx"  ||  takeExtension' x == ".number"                                                                                                 = toFolder "CALC"
    | takeExtension' x == ".ppt"                                                                                                                                                                     = toFolder "SLIDE"
    | takeExtension' x == ".zip"                                                                                                                                                                     = toFolder "ZIP"
    | takeExtension' x == ".mobi" || takeExtension' x == ".epub"                                                                                                                                    = toFolder "EBOOK"
    | takeExtension' x == ".exe" || takeExtension' x == ".dmg"                                                                                                                                      = toFolder "EXE"
    | otherwise = toFolder "UNKNOWN"

    where
        takeExtension' :: String -> String
        takeExtension' s =  unpack $ toLower $ pack $ takeExtension s

        toFolder:: String -> IO()
        toFolder folderName= do
            moveIntoDirectory x (root ++ "/" ++ folderName)
            cleanDirectory' xs root

cleanDirectory:: FilePath -> IO()
cleanDirectory root = do
    c <- getAllContents root
    cleanDirectory' c root

conditionalMoveInto':: [FilePath] -> String -> FilePath -> IO()
conditionalMoveInto' [] _ _ = return ()
conditionalMoveInto' (x:xs) folderName root = do
    isFile <- doesFileExist x
    if isFile
        then do
            copyFile x (root ++ "/" ++ folderName ++ "/" ++ takeFileName x)
            print ("File " ++ x ++ "moved into folder " ++ folderName)
            removeFile x
            conditionalMoveInto' xs folderName root
        else
            conditionalMoveInto' xs folderName root


conditionalMoveInto:: String -> String -> FilePath -> IO ()
conditionalMoveInto subs folderName root = do
    c <- getAllContents root
    isDir <- doesDirectoryExist root
    let targetFolder = root ++ "/" ++ folderName
    targetExist <- doesDirectoryExist targetFolder
    unless targetExist (createDirectory targetFolder)
    let filterList = Data.List.filter (\x -> pack subs `isInfixOf` pack (takeFileName x)) c
    when isDir $ conditionalMoveInto' filterList folderName root

