# Find all .zip files in ./*/bin folders, extract Solution.xml and ControlManifest.xml, and output the relevant version values
$binFolders = Get-ChildItem -Path ..\*\bin -Directory -ErrorAction SilentlyContinue

foreach ($binPath in $binFolders) {
	$zips = Get-ChildItem -Path $binPath.FullName -Recurse -Filter *.zip -ErrorAction SilentlyContinue
	foreach ($zip in $zips) {
		$zipName = $zip.FullName
		$tmp = New-TemporaryFile
		try {
			Add-Type -AssemblyName System.IO.Compression.FileSystem
			$zipArchive = [System.IO.Compression.ZipFile]::OpenRead($zipName)

			# Solution.xml
			$solEntry = $zipArchive.Entries | Where-Object { $_.FullName -match 'Solution.xml$' } | Select-Object -First 1
			if ($solEntry) {
				$entryStream = $solEntry.Open()
				$reader = New-Object System.IO.StreamReader($entryStream)
				$xmlContent = $reader.ReadToEnd()
				$reader.Close(); $entryStream.Close()
				$xml = [xml]$xmlContent
				$version = $xml.ImportExportXml.SolutionManifest.Version
				Write-Host ("{0} : Solution.xml Version = {1}" -f $zipName, $version)
			}

			# ControlManifest.xml

			$ctrlEntry = $zipArchive.Entries | Where-Object { $_.FullName -match 'ControlManifest.xml$' } | Select-Object -First 1
			if ($ctrlEntry) {
				$entryStream = $ctrlEntry.Open()
				$reader = New-Object System.IO.StreamReader($entryStream)
				$xmlContent = $reader.ReadToEnd()
				$reader.Close(); $entryStream.Close()
				$xml = [xml]$xmlContent
				$ctrlVersion = $null
				if ($xml.manifest -and $xml.manifest.control) {
					$ctrlVersion = $xml.manifest.control.version
					if (-not $ctrlVersion) {
						$ctrlVersion = $xml.manifest.control.Attributes["version"]
					}
				}
				if ($ctrlVersion) {
					Write-Host ("{0} : ControlManifest.xml control version = {1}" -f $zipName, $ctrlVersion)
				} else {
					Write-Host ("{0} : ControlManifest.xml found but version not present" -f $zipName)
				}
			}

			$zipArchive.Dispose()
		} catch {
			Write-Warning "Failed to process $($zipName): $($PSItem)"
		} finally {
			Remove-Item $tmp -ErrorAction SilentlyContinue
		}
	}
}
