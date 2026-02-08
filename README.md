# Plesk-MSSQL-DB-Collector

**Plesk-MSSQL-DB-Collector** is a PowerShell script to collect MSSQL databases for a list of Plesk subscriptions using the Plesk database.

It reads subscription domains from a CSV file, queries the Plesk database using a single optimized query, prints the results to the console, and logs them to a file. The script also detects if a domain does not exist in Plesk.

---

## Features

- Reads subscription domains from a CSV file (`subscriptions.csv`).
- Checks if the domain exists in Plesk.
- Retrieves MSSQL databases for each domain using a single JOIN query.
- Prints results to the console for quick visibility and logs the database names list to (`plesk-sqldb-collector.log`).
- Handles empty lines and invalid/non-existent domains gracefully.
- Shows total MSSQL databases found at the end.

---

## Structure

```
.
├── Plesk-sqldb-col.ps1        # Main script
├── subscriptions-sample.csv  # Sample CSV for reference
├── README.md
└── .gitignore
```

---

## Usage

1. Create a CSV file named `subscriptions.csv` in the same path of the script with a header `Subscription` and list all domains you want to check in the same script path.

2. Run the script from PowerShell:

```powershell
.\plesk-sqldb-col.ps1
```

3. Review the console output and the generated log file `plesk-sqldb-collector.log`.

