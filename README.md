# Real SQL Queries: 50 Challenges (Anniversary Edition)

Welcome to the resource repository for the Anniversary Edition of *Real SQL Queries*. Below you will find the database required for the challenges and the complete solution script.

---

## 1. Get the Data
All challenges in this book use the **AdventureWorks2022** sample database.

* **[Download Database Backup (.bak)](https://github.com/analogKid1982/RSQ_Resources/releases/download/1.0/AdventureWorks2022.bak)**
  *(200 MB - Starts download immediately)*

### How to Restore
1.  Download the `.bak` file above.
2.  Move the file to a folder your SQL Server can access (e.g., `C:\SQLBackups\`).
3.  Open the script `00_Setup_Database.sql` in this repository and run it to restore the database to your local machine.

![Restoring Database Instructions](images/restore_instructions.png)

---

## 2. Get the Solutions
You can view the solutions directly in your browser or download the raw file.

* **[View Solutions Script](https://github.com/analogKid1982/RSQ_Resources/blob/main/RSQ50_Anniversary_Edition_All_Solutions.sql)**

---

## Troubleshooting
If you are unable to restore the database using the script provided, you can try the manual method:
1.  Open SSMS.
2.  Right-click **Databases** > **Restore Database...**
3.  Select **Device** and browse to the `.bak` file you downloaded.



<img width="648" height="1584" alt="Install AW Instructions" src="https://github.com/user-attachments/assets/cf426478-2591-4e07-aac4-50d0dce1f390" />
