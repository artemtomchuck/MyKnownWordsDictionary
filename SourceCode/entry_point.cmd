REM TODO: provide your actual path to kitchen. In this script you can see example from author. Or you can create environment variable for FullpathToKitchen
SET FullpathToKitchen="C:\pdi-ce-9.3.0.0-428\data-integration\Kitchen.bat"
SET FolderWithThisCmdScript=%~dp0
call %FullpathToKitchen% -file=%FolderWithThisCmdScript%\jb_entry_point.kjb
