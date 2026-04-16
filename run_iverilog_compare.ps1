param(
    [int]$Iterations = 10,
    [string]$PythonExe = "python"
)

$root = $PSScriptRoot
$desDir = Join-Path $root "DES3"
$pythonScript = Join-Path $root "python\3DES.py"

# Hàm lấy số ngẫu nhiên 64-bit chuẩn
function Get-RandomUInt64 {
    $bytes = New-Object byte[] 8
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    return [BitConverter]::ToUInt64($bytes, 0)
}

# Hàm chuyển số sang chuỗi Hex 16 ký tự (Không dùng Binary nữa để tránh lỗi lệch format)
function To-Hex64([UInt64]$value) {
    return "{0:X16}" -f $value
}

function Parse-UInt64Hex([string]$hex) {
    return [UInt64]::Parse($hex, [System.Globalization.NumberStyles]::HexNumber)
}

# Danh sách Corner Cases
$cornerCases = @(
    @{ P = "0000000000000000"; K1 = "0000000000000000"; K2 = "0000000000000000"; K3 = "0000000000000000" },
    @{ P = "FFFFFFFFFFFFFFFF"; K1 = "FFFFFFFFFFFFFFFF"; K2 = "FFFFFFFFFFFFFFFF"; K3 = "FFFFFFFFFFFFFFFF" },
    @{ P = "0123456789ABCDEF"; K1 = "133457799BBCDFF1"; K2 = "1F1F1F1F0E0E0E0E"; K3 = "0E0E0E0E1F1F1F1F" },
    @{ P = "FEDCBA9876543210"; K1 = "0F1571C947D9E859"; K2 = "0123456789ABCDEF"; K3 = "FEDCBA9876543210" },
    @{ P = "8000000000000000"; K1 = "0101010101010101"; K2 = "FEFEFEFEFEFEFEFE"; K3 = "1B1B1B1B1B1B1B1B" },
    @{ P = "0000000000000001"; K1 = "A5A5A5A5A5A5A5A5"; K2 = "5A5A5A5A5A5A5A5A"; K3 = "3C3C3C3C3C3C3C3C" },
    @{ P = "00000000FFFFFFFF"; K1 = "0123456789ABCDEF"; K2 = "1111111111111111"; K3 = "2222222222222222" },
    @{ P = "FFFFFFFF00000000"; K1 = "89ABCDEF01234567"; K2 = "3333333333333333"; K3 = "4444444444444444" }
)

Push-Location $desDir
try {
    # Biên dịch một lần duy nhất bên ngoài vòng lặp
    Write-Host "Compiling Verilog..." -ForegroundColor Cyan
    & iverilog -g2012 -o des3_sim -f files.f
    if ($LASTEXITCODE -ne 0) { throw "iverilog compile failed" }

    $failures = @()
    $testIndex = 0
    $allCases = $cornerCases

    # Thêm các case ngẫu nhiên nếu cần
    $randomCount = [Math]::Max(0, $Iterations - $cornerCases.Count)
    for ($i = 0; $i -lt $randomCount; $i++) {
        $allCases += @{ 
            P  = To-Hex64 (Get-RandomUInt64)
            K1 = To-Hex64 (Get-RandomUInt64)
            K2 = To-Hex64 (Get-RandomUInt64)
            K3 = To-Hex64 (Get-RandomUInt64)
        }
    }

    foreach ($case in $allCases) {
        $testIndex++
        if ($testIndex -gt $Iterations) { break }

        # Ghi dữ liệu dạng HEX vào file (Khớp với $readmemh trong Verilog)
        Set-Content -Path "idata.txt" -Value $case.P -Encoding ascii
        $keys = "$($case.K1)`n$($case.K2)`n$($case.K3)"
        Set-Content -Path "key123.txt" -Value $keys -Encoding ascii

        # Chạy mô phỏng (VVP)
        & vvp des3_sim | Out-Null

        # Gọi Python để verify kết quả
        $pyOutput = & $PythonExe $pythonScript | Out-String
        $match = ($pyOutput -match "Compare with output.txt: True")

        if (-not $match) {
            $failures += "case $testIndex"
            $statusColor = "Red"
        } else {
            $statusColor = "Green"
        }

        Write-Host "[$testIndex] P=$($case.P) K1=$($case.K1) K2=$($case.K2) K3=$($case.K3) Match=" -NoNewline
        Write-Host "$match" -ForegroundColor $statusColor
    }

    if ($failures.Count -gt 0) {
        Write-Host "`nFailures: $($failures -join ', ')" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "`nAll tests passed: $testIndex" -ForegroundColor Green
    }
}
finally {
    Pop-Location
}