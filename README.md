# SecuForensix

**SecuForensix** is a Windows forensics tool designed to automate evidence collection for investigators and incident responders. It captures system logs, recent user activity, network data, and optionally Android-related artifacts via ADB, storing everything in timestamped forensic reports.

🔗 [Official Website](https://secuforensix.cyberfascinate.com/)

---

## 🚀 Features

* Collects **Windows Event Logs** (System, Application, Security)
* Retrieves **UserAssist data** (program usage history)
* Extracts **recently executed commands** and **netstat connections**
* Automatically downloads and configures **ADB** for Android forensics if needed
* Generates timestamped forensic folders at `C:\ForensicReports\`
* Uses color-coded **PowerShell output** for better readability
* Fully portable `.bat` script – no installation required

---

## ✅ Prerequisites

* Windows OS with:

  * `cmd.exe`
  * `PowerShell`
* Administrator privileges (required for accessing logs, registry, and networking info)
* Internet connection (only required if ADB needs to be downloaded)

---

## 📦 Installation

1. Download the script file: `win.bat`
2. Place it anywhere on your system
3. Right-click the script and choose **Run as Administrator**

---

## 🧪 Usage

1. On execution, **SecuForensix**:

   * Initializes PowerShell-based status messages
   * Creates a timestamped directory inside `C:\ForensicReports\`
   * Checks for **ADB**, and downloads it if missing

2. Performs forensic collection using commands like:

   * `wevtutil` for logs:

     ```cmd
     wevtutil qe System /c:30 /f:text > system_logs.txt
     ```
   * `netstat` for active connections:

     ```cmd
     netstat -ano > netstat.txt
     ```
   * Registry dumps for **UserAssist** keys (recent program usage):

     ```powershell
     Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist\* > userassist.txt
     ```

3. Results are saved in a folder named like:

   ```
   C:\ForensicReports\Fri_05_02_2025_17-45-10\
   ```

---

## 📁 Output Structure

Inside the report folder, you’ll find:

| File Name              | Description                                |
| ---------------------- | ------------------------------------------ |
| `system_logs.txt`      | Last 30 system events via `wevtutil`       |
| `application_logs.txt` | Last 30 application events                 |
| `security_logs.txt`    | Last 30 security logs                      |
| `netstat.txt`          | Snapshot of TCP/UDP/Listening connections  |
| `userassist.txt`       | Program usage via UserAssist registry keys |
| `adb_devices.txt`      | (If ADB enabled) connected Android devices |

---

## 🛠 Troubleshooting

* **ADB not found?** Script will automatically fetch it from the official Android source.
* **Permission denied?** Ensure you're running the `.bat` file as an administrator.
* **No output generated?** Check if the script was blocked by antivirus or run from a protected directory.

---

## 📜 License

MIT License – see [LICENSE](LICENSE) for full details.

---

## 👨‍💻 Developer Info

Created by **Kashish Kanojia**
During **GPCSSI 2024 – Gurugram Police Cyber Security Summer Internship**

### 🏆 Recognition

Received a **Letter of Recommendation** from **Dr. Rakshit Tandon** for outstanding performance in cyber forensics.

[View Letter of Recommendation](#)

---

### 🔗 Connect with Kashish

* 🌐 [Website](https://www.cyberfascinate.com)
* 💼 [LinkedIn](https://www.linkedin.com/in/cyberfascinate)
* 💻 [GitHub](https://www.github.com/cyberfascinate)
* 🐦 [X](https://www.x.com/cyberfascinate)
* 📧 [contact@cyberfascinate.com](mailto:contact@cyberfascinate.com)


Visit the official [SecuForensix Website](https://secuforensix.cyberfascinate.com/) for more details about the tool.

*"Dedicated to advancing cybersecurity through innovative forensic tools and education."*
