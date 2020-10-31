param
(
    [string[]]$f =$(Read-Host "文件1"),
    [string[]]$e = $(Read-Host "实验1包括序号")
)
Function GetLastThursday{
    $today = (Get-Date)
    $dayOfWeek = $today.DayOfWeek
    If ($dayOfWeek -eq 4) {
        $option = Read-Host "这是上周的实验报告吗？[y/n]"
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
    $date = $lastThursday.ToString("MM月dd日")
    Write-Host "实验日期：$date"
    $archiveName = "{0}_{1}_{2}_{3}{4}节"  -f $info.id, $info.name, ($e -Join ""), $date, $info.lessonTime
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
    $pswd = Read-Host "输入密码" -AsSecureString
    $cred = New-Object System.Management.Automation.PSCredential($info.emailFrom,$pswd)
    Send-MailMessage -From $info.emailFrom -To $info.emialTo -Subject $archiveName -Body "自动发送" -Attachments $archiveNameZip -SmtpServer $info.smtp -Credential $cred -Encoding ([System.Text.Encoding]::UTF8)
    Remove-Item $archiveNameZip
}

If ($f.Length -ne $e.Length) {
    Write-Host "两个参数长度不同"
} Else {    
    $info =  (Get-Content "./info.json" | ConvertFrom-Json)
    RenameFiles
}