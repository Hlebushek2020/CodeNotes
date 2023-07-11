SET ProjectName=%1
SET Configuration=%2
SET Platform=%3
SET ProjectDir=%4

SET ZipName=%ProjectName%_%Configuration%_%Platform%.zip
IF %Configuration%=="Release" (
del /f /s "%ProjectDir%Output\bin\%Configuration%_%Platform%\*.xml"
del /f /s "%ProjectDir%Output\bin\%Configuration%_%Platform%\*.pdb"
SET ZipName="%ProjectName%_%Platform%.zip"
)
mkdir "%ProjectDir%..\Output"
del /f "%ProjectDir%..\Output\%ZipName%"
SET sevenZip="C:\Program Files\7-Zip\7z.exe"
IF NOT EXIST %sevenZip% (
SET sevenZip=7z
)
%sevenZip% a -tzip -mx5 -r "%ProjectDir%..\Output\%ZipName%" "%ProjectDir%Output\bin\%Configuration%_%Platform%\*"