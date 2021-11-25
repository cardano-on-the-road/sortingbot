# Sortingbot

The purpose of the Sortingbot is to give a command-line interface tool to manage and order a directory.



## How execute it

1. Install cabal on your machine
    
    a. 	**MacOS** 

        ```bash
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        brew install cabal-install 
       ```

	b. **Linux (Debian)**
        
        ```bash
		sudo apt-get update -y
		sudo apt-get install -y cabal-install
        ````
	
	c. **Windows (Not tested)**
        
        [Download Binary](https://www.haskell.org/cabal/download.html)
        [Install WSL and then follow the point B](https://www.youtube.com/watch?v=X-DHaQLrBi8)

2.  Clone this repository ```git clone https://github.com/cardano-on-the-road/sortingbot.git```
3.  Get into your local folder repository
4.  Execute the command  ```cabal install```
5.  Cabal will show you where the executable will be delivered. The path should be something like *"/Users/valeriomellini/.cabal/bin/sortingbot"*
6.  (OPT) Add the cabal-bin folder into your environment variable to execute easier your Cabal bins. 

## Examples of usage 

1. TO FLAT THE FILESYSTEM TREE INTO THE ROOT FOLDER <br> 
   sortingbot -F -r [ROOT_PATH] 
2. TO FLAT AND ORDER THE FYLESYSTEM TREE UNDER THE ROOT <br>
   sortingbot -O -r [ROOT_PATH] 
3. TO GROUP THE FILES THAT MATCH WITH THE SUBSTRING INTO A FOLDER <br>
   cabal run sortingbot -G -f [FOLDER_NAME] -r [ROOT_PATH] -s [SUBSTRING]


OPTIONS
  -h              --help                     Show this help message and exit <br>
  -f FOLDER_NAME  --folder-name=FOLDER_NAME  The folder name where you want to group files (to use with -G) <br>
  -r ROOT_FOLDER  --root=ROOT_FOLDER         The root folder where you want to execute the ORDER, FLAT or GROUP process <br>
  -s SUBSTRING    --substring=SUBSTRING      Define the substring that match with the files you want to group <br>
  -O              --order                    Flag to enable the ORDER process <br>
  -F              --flat                     Flag to enable the FLAT process <br>
  -G              --group                    Flag to enable the GROUP function <br>
