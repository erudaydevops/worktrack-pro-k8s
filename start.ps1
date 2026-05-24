# start.ps1
# Run this script to start the voting app and open it in your browser
# Usage: Right-click > "Run with PowerShell"  OR  just run: .\start.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Cats vs Dogs - Voting App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if pods are running
Write-Host "Checking pods..." -ForegroundColor Yellow
kubectl get pods
Write-Host ""

# Start port-forward for voting app in background
Write-Host "Starting port-forward for Voting App (port 30004)..." -ForegroundColor Yellow
$job1 = Start-Job { kubectl port-forward service/voting-service 30004:80 }

# Start port-forward for result app in background
Write-Host "Starting port-forward for Result App (port 30005)..." -ForegroundColor Yellow
$job2 = Start-Job { kubectl port-forward service/result-service 30005:80 }

# Wait a moment for port-forwards to connect
Write-Host "Waiting for connections to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 4

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Apps are READY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Vote Here    --> http://localhost:30004" -ForegroundColor Green
Write-Host "  Results Here --> http://localhost:30005" -ForegroundColor Green
Write-Host ""

# Open both in browser automatically
Start-Process "http://localhost:30004"
Start-Sleep -Seconds 1
Start-Process "http://localhost:30005"

Write-Host "Press ENTER to stop the apps and exit..." -ForegroundColor Red
Read-Host

# Stop port-forwards when user presses Enter
Stop-Job $job1, $job2
Remove-Job $job1, $job2
Write-Host "Stopped. Goodbye!" -ForegroundColor Cyan
