set PROJECTNAME=Project_Name

if exist "vivado.jou" (
    del vivado.jou
) else (
    echo vivado.jou does not exist
)

if exist "vivado.log" (
    del vivado.log
) else (
    echo vivado.log does not exist
)

if exist ".Xil" (
    rmdir .Xil
) else (
    echo .Xil does not exist
)

if exist "%PROJECTNAME%" (
    echo %PROJECTNAME% is going to be deleted. 
    rmdir /s %PROJECTNAME%
) else (
    echo Vivado Project = %PROJECTNAME% does not exist.
)