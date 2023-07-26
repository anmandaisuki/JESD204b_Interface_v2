
set PROJECTNAME=Project_Name

if exist "%PROJECTNAME%" (
    echo %PROJECTNAME% is going to be deleted. 
    rmdir /s %PROJECTNAME%
) else (
    echo Vivado Project named %PROJECTNAME% does not exist. Recreating Project.....
)

vivado -mode batch -source src/create_project.tcl -tclargs %PROJECTNAME%
