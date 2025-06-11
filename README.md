# 🩺 System Health Monitoring + Auto-Healing Shell Script

This is a lightweight and fully automated **System Health Monitoring + Auto-Healing script** written in pure Bash. Designed to give insights into system performance and ensure critical services stay running — without manual intervention.

## 🔧 What It Does

- ✅ Monitors CPU, Memory, and Disk usage
- ✅ Detects high resource usage (threshold-based)
- ✅ Checks internet connectivity (via ping)
- ✅ Monitors a custom service and auto-restarts it if it fails
- ✅ Sends email alerts for critical system issues
- ✅ Logs all events and metrics with timestamps (in IST)
- ✅ Automatically scheduled to run daily at 11:30 PM using crontab

## 🛠️ Technologies Used

- Bash Shell Scripting
- Linux system utilities: `top`, `df`, `free`, `ping`, `pgrep`, `mail`
- `crontab` for daily scheduling
- Log files organized by date

## 📂 Directory Structure

.
├── healthCheck.sh # Main monitoring script
├── fakeService.sh # Simulated service script for monitoring
├── logs/ # Daily log files with timestamps
└── README.md # You're here!


## 📬 Alerts

Email notifications are sent when:
- CPU, Memory, or Disk usage exceeds 90%
- Internet connection is down
- The monitored service fails to restart

## 🕒 Scheduling (Crontab)

To schedule this script to run every day at 11:30 PM IST:

30 23 * * * /path/to/healthCheck.sh >> /path/to/healthCheck_cron.log 2>&1


Replace `/path/to/` with the actual path to your script.

## 📌 Setup

1. Ensure `mailutils` is installed for sending alerts.
2. Customize your `ALERT_EMAIL` in `healthCheck.sh`.
3. Run the script manually or set up a cron job as described above.

## 📘 Learnings

This project was built to reinforce Linux and shell scripting skills by solving a real-world problem. It touches on:

- Process monitoring and auto-recovery
- Real-time system health diagnostics
- Log management
- Automation with `cron`
- Writing clean, modular Bash scripts

---

> 💡 If you're learning Linux or Bash scripting, try building your own version of this project. It's a great way to gain practical experience while creating something useful!

---

## 🔗 Connect

Made with 💻 by [Saksham Gupta](https://www.linkedin.com/in/your-link).  


