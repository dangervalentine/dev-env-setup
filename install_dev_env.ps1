# Development Environment Setup Script
# This script installs and configures common development tools

# Setup logging
$logFile = Join-Path $PSScriptRoot "install_dev_env.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"=== Installation Log Started at $timestamp ===" | Out-File $logFile
"Script running from: $PSScriptRoot" | Out-File $logFile -Append

function Write-Log {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    $logMessage = "[$timestamp] [$Type] $Message"
    $logMessage | Out-File $logFile -Append
    Write-Host $Message
}

# Ensure running with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Log "Script must be run as Administrator!" "ERROR"
    Break
}

# Install Chocolatey (Windows Package Manager)
Write-Log "Installing Chocolatey..." "INFO"
try {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Log "Chocolatey installation completed successfully" "SUCCESS"
}
catch {
    Write-Log "Failed to install Chocolatey: $($_.Exception.Message)" "ERROR"
    Break
}

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Install common development tools
Write-Log "Installing development tools..." "INFO"
$tools = @(
    "git",
    "vscode",
    "nodejs-lts",
    "python",
    "visualstudio2022-workload-nativedesktop",
    "visualstudio2022-workload-manageddesktop",
    "visualstudio2022-workload-netweb",
    "dotnet-sdk",
    "postman",
    "docker-desktop",
    "openjdk17",
    "androidstudio"
)

foreach ($tool in $tools) {
    Write-Log "Checking/Installing $tool..." "INFO"
    try {
        $result = choco install $tool -y
        if ($result -match "already installed") {
            Write-Log "$tool is already installed" "SKIP"
        }
        else {
            Write-Log "$tool installed successfully" "SUCCESS"
        }
    }
    catch {
        Write-Log ("Failed to install " + $tool + ": " + $_.Exception.Message) "ERROR"
    }
}

# Configure Android SDK environment variables
Write-Log "Configuring Android SDK environment variables..." "INFO"
try {
    $androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"
    $javaHomePath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.14.7-hotspot"

    # Set ANDROID_HOME
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdkPath, "Machine")
    Write-Log "Set ANDROID_HOME to $androidSdkPath" "SUCCESS"

    # Set JAVA_HOME
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHomePath, "Machine")
    Write-Log "Set JAVA_HOME to $javaHomePath" "SUCCESS"

    # Add platform-tools to PATH
    $platformToolsPath = "$androidSdkPath\platform-tools"
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if (-not $currentPath.Contains($platformToolsPath)) {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$platformToolsPath", "Machine")
        Write-Log "Added platform-tools to PATH" "SUCCESS"
    }

    # Add Java bin to PATH
    $javaBinPath = "$javaHomePath\bin"
    if (-not $currentPath.Contains($javaBinPath)) {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$javaBinPath", "Machine")
        Write-Log "Added Java bin to PATH" "SUCCESS"
    }
}
catch {
    Write-Log "Failed to configure Android SDK environment variables: $($_.Exception.Message)" "ERROR"
}

# Install VS Code extensions
Write-Log "Installing VS Code extensions..." "INFO"
$extensions = @(
    "ms-vscode.csharp",
    "ms-python.python",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "ms-azuretools.vscode-docker",
    "msjsdiag.vscode-react-native",
    "redhat.java",
    "vscjava.vscode-java-debug",
    "vscjava.vscode-java-pack"
)

foreach ($extension in $extensions) {
    Write-Log "Installing VS Code extension: $extension" "INFO"
    try {
        $result = code --install-extension $extension
        if ($result -match "already installed") {
            Write-Log "Extension $extension is already installed" "SKIP"
        }
        else {
            Write-Log "Extension $extension installed successfully" "SUCCESS"
        }
    }
    catch {
        Write-Log ("Failed to install extension " + $extension + ": " + $_.Exception.Message) "ERROR"
    }
}

# Configure VS Code to use Fira Code
Write-Log "Configuring VS Code to use Fira Code..." "INFO"
try {
    $settingsPath = "$env:APPDATA\Code\User\settings.json"
    $settings = @{
        "editor.fontFamily"    = "'Fira Code', Consolas, 'Courier New', monospace"
        "editor.fontLigatures" = $true
    }

    if (Test-Path $settingsPath) {
        $existingSettings = Get-Content $settingsPath | ConvertFrom-Json
        $settings = $existingSettings | ConvertTo-Json | ConvertFrom-Json
        $settings | Add-Member -NotePropertyName "editor.fontFamily" -NotePropertyValue "'Fira Code', Consolas, 'Courier New', monospace" -Force
        $settings | Add-Member -NotePropertyName "editor.fontLigatures" -NotePropertyValue $true -Force
    }

    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
    Write-Log "VS Code font configuration completed successfully" "SUCCESS"
}
catch {
    Write-Log ("Failed to configure VS Code font settings: " + $_.Exception.Message) "ERROR"
}

# Configure Git
Write-Log "Configuring Git..." "INFO"
try {
    git config --global core.autocrlf true
    git config --global init.defaultBranch main
    Write-Log "Git configuration completed successfully" "SUCCESS"
}
catch {
    Write-Log "Failed to configure Git: $($_.Exception.Message)" "ERROR"
}

# Create development directories
Write-Log "Creating development directories..." "INFO"
$devDirs = @(
    "$env:USERPROFILE\Documents\Projects",
    "$env:USERPROFILE\Documents\Projects\Web",
    "$env:USERPROFILE\Documents\Projects\Desktop",
    "$env:USERPROFILE\Documents\Projects\Mobile",
    "$env:USERPROFILE\Documents\Projects\Android"
)

foreach ($dir in $devDirs) {
    if (-not (Test-Path $dir)) {
        try {
            New-Item -ItemType Directory -Path $dir | Out-Null
            Write-Log "Created directory: $dir" "SUCCESS"
        }
        catch {
            Write-Log ("Failed to create directory " + $dir + ": " + $_.Exception.Message) "ERROR"
        }
    }
    else {
        Write-Log "Directory already exists: $dir" "SKIP"
    }
}

Write-Log "Development environment setup completed!" "SUCCESS"
Write-Log "Please restart your computer to ensure all changes take effect." "INFO"
Write-Log "Log file location: $logFile" "INFO"

# Pause the script until user presses a key
Write-Host "`nPress Enter to close this window..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
