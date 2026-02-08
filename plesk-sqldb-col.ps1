$csvPath = ".\subscriptions.csv"
$sampleCsvPath = ".\subscriptions-sample.csv"
$logPath = ".\plesk-sqldb-collector.log"

if (-not (Test-Path $csvPath)) {
    if (Test-Path $sampleCsvPath) {
        Write-Host "Warning: subscriptions.csv not found.. Using subscriptions-sample.csv" -ForegroundColor Yellow
        $csvPath = $sampleCsvPath
    }
    else {
        Write-Host "Error: No subscriptions CSV file found. Create the file or check file name." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nStarting MSSQL DB collection for Plesk subscriptions..." -ForegroundColor Yellow
$subscriptions = Import-Csv $csvPath
$totalFound = 0

foreach ($row in $subscriptions) {

    $domain = $row.Subscription.Trim()
    if ([string]::IsNullOrWhiteSpace($domain)) { continue }

    Write-Host "Processing subscription: $domain" -ForegroundColor Yellow

    $sql = @"
SELECT db.name
FROM domains d
LEFT JOIN data_bases db
  ON db.dom_id = d.id
 AND db.type = 'mssql'
WHERE d.name = '$domain';
"@

    try {
        $result = plesk db -N -e $sql

        #Domain Check
        if (-not $result) {
            Write-Host "  Domain does NOT exist in Plesk" -ForegroundColor Red
            continue
        }

        #Filter out null results from LEFT JOIN
        $dbs = $result | Where-Object { $_ -and $_ -ne "NULL" }

        if ($dbs) {
            $dbs | Tee-Object -FilePath $logPath -Append
            $count = $dbs.Count
            $totalFound += $count
            Write-Host "  Found $count MSSQL DB(s)" -ForegroundColor Green
        }
        else {
            Write-Host "  Domain has NO MSSQL databases" -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "  Error while processing $domain : $_" -ForegroundColor Red
    }
}

Write-Host "Collection completed. Total MSSQL DBs found: $totalFound" -ForegroundColor Green

