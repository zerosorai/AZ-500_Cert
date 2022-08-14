

# Module 3: Auditing a Database

## Exercise 1: Enable auditing on your database

### Task 1: Lab Setup

1.  In your browser, navigate to the following URL to open the ARM template:

    ```cli
    https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftLearning%2FAZ-500-Azure-Security%2Fmaster%2FAllfiles%2FLabs%2FMod3_Lab02%2Fazuredeploy.json 
    ```

1.  **Under Resource** group click create new and use the default name "**Mod3Lab2**"

1.  You can use the default **populated SQL server** name with a **unique** string added to make a **globaly unique** name

1.  Click **Purchase**
warning
**Note**: You must wait for the SQL database with the test data to deploy

### Task 2: Enable auditing on your database

1.  Select your resource group created in the lab setup

2.  **Select** the SQL server **your unique SQL Server name**

3.  **Under Security**, select **Auditing**

4.  **Switch Auditing** to **ON**.

5.  Select **storage** as the location to send the audit logs to

6.  Click **Configure**

7.  Select **Your Subscription**

8.  Click **Storage account** then if necessary click **Create New**. The Create storage account blade should open..

9.  Name the storage account **mod3lab2yourname** ensuring you replace **yourname** with a unique name using lowercase letters

10. **Click OK**.

11. Change the retention days to **5** and click **OK** 

12. Click **Save** to save the **auditing configuration**

## Exercise 2: Review audit logs

### Task 1: Review audit logs on the SQL DB.

1.  To review audit logs for a database return to the resource group created in the lab setup

2.  Click **AZ500LabDb (your unique SQL Server name/AZ500LabDb)** to select your test database

3.  **Under Security**, select **Auditing**
  
    **Note**: The Auditing looks off here but it is set on the underlying server level so it is turned on for this database


4.  Click **View Audit Logs**.

  **Note**: Here you will review the output of the audit logs of the database including any attempted SQL injections. Since this is a test database created recently, there will be minimal audits if any in the log at the current time.

  If server auditing is enabled, the database-configured audit will exist side-by-side with the server audit.
Notice that you can select for audit logs to be written to an Azure storage account, to a Log Analytics workspace for consumption by Azure Monitor logs, or to Event Hub for consumption using an event hub. You can configure any combination of these options, and audit logs will be written to each.



**Results**: You have now setup up auditing on a SQL database and reviewed where to view the auditing output
