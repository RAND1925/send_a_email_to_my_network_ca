param
(
    [string[]]$f =$(Read-Host "�ļ�1"),
    [string[]]$e = $(Read-Host "ʵ��1�������")
)
Function GetLastThursday{
    $today = (Get-Date)
    $dayOfWeek = $today.DayOfWeek
    If ($dayOfWeek -eq 4) {
        $option = Read-Host "�������ܵ�ʵ�鱨����[y/n]"
        While($True) {
            If ($option -eq"y" -or $option -eq "Y") {
                Write-Output $today
            } ElseIf ($option -eq "n" -or $option -eq "N") {
                Write-Output $today.AddDays(-7)
            }
        }
    } Else {
        Write-Output $today.AddDays(-(($dayOfWeek-4) % 7))
    }
}

function RenameFiles{
    $lastThursday = GetLastThursday
    $date = $lastThursday.ToString("MM��dd��")
    Write-Host "ʵ�����ڣ�$date"
    $archiveName = "{0}_{1}_{2}_{3}{4}��"  -f $info.id, $info.name, ($e -Join ""), $date, $info.lessonTime
    $archiveNameZip = $archiveName + ".zip"
    $out = @()
    For ($i = 0; $i -lt $f.Length; $i++){
        $rawFileName = $f[$i]
        $experimentName = $e[$i]
        $extention = [System.IO.Path]::GetExtension($rawFileName)
        $fileName = "{0}_{1}_{2}_{3}{4}"  -f $info.id, $info.name, $experimentName, $date, $extention
        Write-Host $fileName
        Copy-Item $rawFileName -Destination $fileName
        $out += $fileName
    }
    Write-Host $archiveNameZip
   
    $compress = @{
        LiteralPath= $out
        CompressionLevel = "Fastest"
        DestinationPath = $archiveName
    }
    Compress-Archive @compress -Force
    $pswd = Read-Host "��������" -AsSecureString
    $cred = New-Object System.Management.Automation.PSCredential($info.emailFrom,$pswd)
    Send-MailMessage -From $info.emailFrom -To $info.emialTo -Subject $archiveName -Body "�Զ�����" -Attachments $archiveNameZip -SmtpServer $info.smtp -Credential $cred -Encoding ([System.Text.Encoding]::UTF8)
    Remove-Item $archiveNameZip
}

If ($f.Length -ne $e.Length) {
    Write-Host "�����������Ȳ�ͬ"
} Else {    
    $info =  (Get-Content "./info.json" | ConvertFrom-Json)
    RenameFiles
}