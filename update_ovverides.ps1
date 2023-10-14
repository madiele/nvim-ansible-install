$nvim_config = "$env:APPDATA\..\Local\nvim"
write-host "Copying overides to $nvim_config\lua"
Copy-Item -Path ".\lua\" -Destination "$nvim_config\" -Recurse -Force
