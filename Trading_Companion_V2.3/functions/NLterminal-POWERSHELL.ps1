[Console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$filepath = (Get-Item -Path .\ -Verbose).FullName

while (1 -eq 1) {
    $prompt = Read-Host -Prompt 'ENTER A SYMBOL (or "exit" to quit)'
    if ($prompt -eq 'exit') {
        break
    } else {
        Clear
        Write-Host "Retrieving News..."

        # Fetch the raw HTML content
        $html = "https://query1.finance.yahoo.com/v1/finance/search?q=$prompt"
        $response = Invoke-WebRequest -Uri $html -Headers @{ "User-Agent" = "Mozilla/5.0" }

        # Save the raw HTML content to a variable
        $rawContent = $response.Content

        # Save the raw HTML content to a file
        $tempFilePath = Join-Path -Path $filepath -ChildPath "temp"
        $rawContent | Set-Content -Path $tempFilePath

        # Read the JSON content from the temp file
        $jsonContent = Get-Content -Path $tempFilePath -Raw | ConvertFrom-Json

        # Extract today's and yesterday's news
        $allNews = $jsonContent.news
        $todayDate = (Get-Date).Date
        $yesterdayDate = $todayDate.AddDays(-1)

        # Filter today's news
        $todayNews = $allNews | Where-Object {
            $publishTime = ([datetime]'1970-01-01').AddSeconds($_.providerPublishTime)
            $publishTime.Date -eq $todayDate
        }

        # Filter yesterday's news
        $yesterdayNews = $allNews | Where-Object {
            $publishTime = ([datetime]'1970-01-01').AddSeconds($_.providerPublishTime)
            $publishTime.Date -eq $yesterdayDate
        }

        # Process yesterday's news
        if ($yesterdayNews) {
            $yesterdayTitles = @()
            $yesterdayTimes = @()
            $yesterdayAmPm = @()
            foreach ($newsItem in $yesterdayNews) {
                if ($newsItem.providerPublishTime -ne $null) {
                    $yesterdayTitles += $newsItem.title
                    $publishTime = ([datetime]'1970-01-01').AddSeconds($newsItem.providerPublishTime)
                    $yesterdayTimes += $publishTime.ToString("hh:mm")
                    $yesterdayAmPm += $publishTime.ToString("tt")
                } else {
                    Write-Host -ForegroundColor Yellow "Skipping news item with missing publish time."
                }
            }

            # Reverse the order of yesterday's news using array slicing
            $yesterdayTitles = $yesterdayTitles[-1..-($yesterdayTitles.Count)]
            $yesterdayTimes = $yesterdayTimes[-1..-($yesterdayTimes.Count)]
            $yesterdayAmPm = $yesterdayAmPm[-1..-($yesterdayAmPm.Count)]
        } else {
            Write-Host -BackgroundColor Red "NO NEWS AVAILABLE FOR YESTERDAY"
        }

        # Output yesterday's news
        if ($yesterdayTitles) {
            Write-Host "Yesterday's News:" -BackgroundColor DarkCyan
            for ($i = 0; $i -lt $yesterdayTitles.Count; $i++) {
                $formattedTime = "$($yesterdayTimes[$i])$($yesterdayAmPm[$i].ToLower())"
                $title = $yesterdayTitles[$i]
                $link = $yesterdayNews[$i].link
                Write-Host "$formattedTime " -NoNewline
                Write-Host "$title" -ForegroundColor Cyan -NoNewline
                Write-Host " ($link)" -ForegroundColor Yellow
            }
        }

        # Process today's news
        if ($todayNews) {
            $todayTitles = @()
            $todayTimes = @()
            $todayAmPm = @()
            foreach ($newsItem in $todayNews) {
                if ($newsItem.providerPublishTime -ne $null) {
                    $todayTitles += $newsItem.title
                    $publishTime = ([datetime]'1970-01-01').AddSeconds($newsItem.providerPublishTime)
                    $todayTimes += $publishTime.ToString("hh:mm")
                    $todayAmPm += $publishTime.ToString("tt")
                } else {
                    Write-Host -ForegroundColor Yellow "Skipping news item with missing publish time."
                }
            }

            # Reverse the order of today's news using array slicing
            $todayTitles = $todayTitles[-1..-($todayTitles.Count)]
            $todayTimes = $todayTimes[-1..-($todayTimes.Count)]
            $todayAmPm = $todayAmPm[-1..-($todayAmPm.Count)]
        } else {
            Write-Host -BackgroundColor Red "NO NEWS AVAILABLE FOR TODAY"
        }

        # Output today's news
        if ($todayTitles) {
            Write-Host "Today's News:" -BackgroundColor DarkGreen
            for ($i = 0; $i -lt $todayTitles.Count; $i++) {
                $formattedTime = "$($todayTimes[$i])$($todayAmPm[$i].ToLower())"
                $title = $todayTitles[$i]
                $link = $todayNews[$i].link
                Write-Host "$formattedTime " -NoNewline
                Write-Host "$title" -ForegroundColor Cyan -NoNewline
                Write-Host " ($link)" -ForegroundColor Yellow
            }
        }

        # Clean up the temp file
        Remove-Item -Path $tempFilePath -Force

        # Reset news variables
        $todayNews = $null
        $yesterdayNews = $null
        $todayTitles = $null
        $todayTimes = $null
        $todayAmPm = $null
        $yesterdayTitles = $null
        $yesterdayTimes = $null
        $yesterdayAmPm = $null
    }
}