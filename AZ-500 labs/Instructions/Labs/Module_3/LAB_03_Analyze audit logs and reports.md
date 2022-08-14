

# Module 3: Analyze audit logs and reports

## Exercise 1: Get started with SQL database auditing

### Task 0: Lab Setup

1.  In your browser, navigate to the following URL to open the ARM template:

    ```cli
    https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftLearning%2FAZ-500-Azure-Security%2Fmaster%2FAllfiles%2FLabs%2FMod3_Lab03%2Fazuredeploy.json
    ```

1.  Under **Resource group** click create new and use the default name "**Mod3Lab3**"

1.  You can use the default populated SQL server name with a unique string added to make a globaly unique name.

1.  Click **Purchase** 

### Task 1 - Set up auditing for your database

1.  **Navigate** to **Resource Groups**

1.  **Select** your resource group created above ("**Mod3Lab3**" if you chose the same name as the instructions)

1.  **Click** your **SQL Server** name

1.  On the left pane click auditing

1.  **Change** auditing to **ON** from **OFF**.
warning
**Note**: You now have the option to select where you wish audit logs to be written to.


1.  **Select** all **3 options**, **Storage**, **Log analytics**, **Event hub**.

1.  **Under Storage**, **Click** configure.

1.  **Click subscription** and select your subscription

1.  **Click** storage account

1.  Under create storage account input a unique name (**e.g. mod3lab3yourname**)

1.  **Click OK**.

1.  When validated click **OK** again

1.  Under Log analytics click configure

1.  **Click** create new workspace

1.  Enter the following settings

     |Log Analytics Workspace|Subscription|Resource Group | Location| Pricing   Tier|
     |-----------------------|------------|---------------|---------|   -------------
     |Mod3Lab3YOURNAME|Your Subscription|The RG you created in the lab setup|   East US | Per GB (2018)|

1.  **Click OK**.
warning
**Note**: Setting up Event Hub requires extra steps as the Azure portal does not allow you to create an event hub from this location


1.  To set up an **Event Hub** for configuration, click **Azure Cloud Shell** at the top of the **Portal**.

1.  **Enter** the following **Powershell Commands**.

    ***Note*** Replace the section **{GlobalUniqueName}** with a globally unique name

    ```powershell
    New-AzEventHubNamespace -ResourceGroupName Mod3Lab3  -NamespaceName {GlobalUniqueName} -Location eastus
    ```

    ```powershell
    New-AzEventHub -ResourceGroupName Mod3Lab3 -NamespaceName {GlobalUniqueName}  -EventHubName Mod3Lab3 -MessageRetentionInDays 3
    ```

    Return to the Advanced Data Security blade in portal. (**Note** The Event Hub Namespace will be the unique name you specified).

1.  When these commands have completed click **configure under event hubs**

1.  **Select** the following information

     | Subscription|Hub Namespace|Hub Name| Hub Policy Name|
     |-------------|-------------|--------|----------------|
     |Your Subscription| Mod3Lab3|mod3lab3|RootManageSharedAccessKey|


1.  **Click OK**

1.  You can now click **Save** on the **Auditing Settings** page

    **Result**: You have now turned on auditing for your SQL database


1.  To access the logs return to the **Resource group** where the **SQL Database** and **Server reside**

1.  **Select** the **Mod3Lab3** Log analytics workspace you created earlier

1.  **Click** logs

1.  **Click Get Started**

2.  In the query space enter the following code and **click Run**.

    ```cli
    Event | where Source  == "MSSQLSERVER" 
    ```

3.  You will not see any results, please read the below warning
warning
**Note**: Because we have set up logs on a new database with test data, there are minimal log entries available to see. To show how logs are displayed, we can use the example log analytics website that is populated with example data.


### Task 2 - Analyze audit logs and reports

1.  Visit **`https://portal.loganalytics.io/demo`** in a new web browser tab, this will direct you to a demo log analytics workspace with demo data populated

1.  In the query space enter the following code and **click Run**.

    ```cli
    Event | where Source  == "MSSQLSERVER" 
    ```

1.  From here you can expand some of the example audit logs to view what they would look like in a live system

1.  In the query space enter the following code and **Click Run**.

    ```cli
    Event 
    | where EventLevelName == "Error" 
    | where TimeGenerated > ago(1d) 
    | where Source != "HealthService" 
    | where Source != "Microsoft-Windows-DistributedCOM" 
    | summarize count() by Source
    ```

1.  **Click chart**

1.  From here you can review how log data can be displayed as chart data

1.  **Click** the **Stacked Column** drop down and select **Pie**

1.  Here you can see the same data as a different chart

1.  From the top right of the window you can **Click Export** to export the data as **CSV**.

 The query language used by log analytics is called the Kusto query language. The full documentation for this language can be found here **`https://docs.microsoft.com/en-us/azure/kusto/query/`**



**Results**: You have now completed the setup of logs on a SQL database and run queries against the log analytics workspace to view the audit logs that will be generated


