
function ZipFile(){
  $today = (Get-Date)
    $dayOfWeek = $today.DayOfWeek
    If ($dayOfWeek -eq 4) {
        $option = Read-Host "这是上周的实验报告吗？[y/n]"
        While($True) {
            If ($option -eq"y" -or $option -eq "Y") {
                $experimentDate = $today
                Break
            } ElseIf ($option -eq "n" -or $option -eq "N") {
                $experimentDate = $today.AddDays(-7)
                Break
            }
        }
    } Else {
        $experimentDate = $today.AddDays(-(($dayOfWeek-4) % 7))
    }
    $date = $experimentDate.ToString("MM月dd日")
    $lesson = "910"
    $info =  (Get-Content "info.json" | ConvertFrom-Json)
    echo $info
    $fileNumbers = 9, 10
    $fileLessons = "", ""
    $fileNameFmt = "{0}_{1}_{2}{3}_{4}" 
    $fileName = $fileNameFmt -f $info.id, $name,"x" , $date, "xx"
    Write-Host $fileName
       
}
Write-Host "xxx"

ZipFile
   