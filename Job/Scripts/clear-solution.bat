SET SolutionDir=%1

for /d /r %SolutionDir% %%d in (*Output*) do (
rmdir /s /q %%d\
)