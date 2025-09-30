dotnet build-server shutdown
Remove-Item -Recurse -Force "$env:USERPROFILE\.nuget\packages\talxis.devkit.build.dataverse.tasks"
Remove-Item -Recurse -Force "$env:USERPROFILE\.nuget\packages\talxis.devkit.build.dataverse.solution"
Remove-Item -Recurse -Force "$env:USERPROFILE\.nuget\packages\talxis.devkit.build.dataverse.plugin"
Remove-Item -Recurse -Force "$env:USERPROFILE\.nuget\packages\talxis.devkit.build.dataverse.pcf"