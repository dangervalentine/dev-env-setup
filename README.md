# Development Environment Setup

This repository contains a PowerShell script (`install_dev_env.ps1`) that automates the installation and configuration of a comprehensive development environment for Windows.

## What This Script Does

The script automatically installs and configures:

### Core Development Tools
- Git
- Visual Studio Code
- Node.js (LTS)
- Python
- .NET SDK
- Docker Desktop
- Postman

### Visual Studio Components
- Native Desktop Development
- Managed Desktop Development
- .NET Web Development

### Android Development
- OpenJDK 17
- Android Studio

### VS Code Extensions
- C# (ms-vscode.csharp)
- Python (ms-python.python)
- ESLint (dbaeumer.vscode-eslint)
- Prettier (esbenp.prettier-vscode)
- Docker (ms-azuretools.vscode-docker)
- React Native (msjsdiag.vscode-react-native)
- Java (redhat.java)
- Java Debug (vscjava.vscode-java-debug)
- Java Extension Pack (vscjava.vscode-java-pack)

### Environment Configuration
- Sets up JAVA_HOME
- Sets up ANDROID_HOME
- Configures PATH variables
- Sets up Git configuration
- Creates development project directories

## Manual Steps Required

### 1. Android Studio Setup
After installation, open Android Studio and:
1. Complete the initial setup wizard
2. Go to Tools → SDK Manager
3. In the "SDK Platforms" tab, install:
   - Android 17.0
   - Android 16.0
4. In the "SDK Tools" tab, ensure these are installed:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
   - Android SDK Platform-Tools
   - Android SDK Tools
   - NDK (if needed for native development)

### 2. Visual Studio Setup
1. Open Visual Studio Installer
2. Modify your installation to include:
   - .NET desktop development
   - Desktop development with C++
   - Universal Windows Platform development
3. Install any additional components you need

### 3. Docker Desktop
1. Start Docker Desktop
2. Complete the initial setup wizard
3. Enable WSL 2 if prompted
4. Sign in to your Docker account (optional)

### 4. Node.js Verification
1. Open a new terminal
2. Run `node --version` to verify installation
3. Run `npm --version` to verify npm installation

### 5. Python Verification
1. Open a new terminal
2. Run `python --version` to verify installation
3. Run `pip --version` to verify pip installation

### 6. Git Configuration
1. Open a terminal
2. Set your Git identity:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### 7. VS Code Configuration
1. Open VS Code
2. Install the Fira Code font if not already installed
3. Verify all extensions are installed
4. Configure any additional settings as needed

### 8. Environment Variables
After running the script, verify these environment variables are set:
1. JAVA_HOME
2. ANDROID_HOME
3. Path includes:
   - %JAVA_HOME%\bin
   - %ANDROID_HOME%\platform-tools

## Troubleshooting

### Android SDK Issues
If you encounter Android SDK-related issues:
1. Verify ANDROID_HOME is set correctly
2. Check if platform-tools are in your PATH
3. Ensure you have accepted all necessary licenses:
   ```bash
   sdkmanager --licenses
   ```

### Java Issues
If you encounter Java-related issues:
1. Verify JAVA_HOME is set correctly
2. Check if java is in your PATH
3. Run `java -version` to verify installation

### VS Code Issues
If extensions aren't installing:
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Manually install any missing extensions

## Logging

The script creates a log file (`install_dev_env.log`) in the same directory. Check this file if you encounter any issues during installation.

## Requirements

- Windows 10 or later
- Administrator privileges
- Internet connection
- At least 20GB of free disk space

## Running the Script

1. Open PowerShell as Administrator
2. Navigate to the script directory
3. Run:
   ```powershell
   .\install_dev_env.ps1
   ```
4. Restart your computer after completion

## Notes

- The script requires administrator privileges
- Some installations may require manual intervention
- A system restart is recommended after running the script
- The script creates a log file for troubleshooting
