# Module 2: Lab 20 - Azure Blueprints


**Scenario**

When you learn how to create and assign blueprints, you can define common patterns to develop reusable and rapidly deployable configurations based on Azure Resource Manager templates, policy, security, and more. In this tutorial, you learn to use Azure Blueprints to do some of the common tasks related to creating, publishing, and assigning a blueprint within your organization. These tasks include:

- Create a new blueprint and add various supported artifacts
- Make changes to an existing blueprint still in Draft
- Mark a blueprint as ready to assign with Published
- Assign a blueprint to an existing subscription
- Check the status and progress of an assigned blueprint
- Remove a blueprint that has been assigned to a subscription


## Exercise 1: Create a blueprint in the portal

### Task 1: Create a blueprint


The first step in defining a standard pattern for compliance is to compose a blueprint from the available resources. In this example, create a new blueprint named **MyBlueprint** to configure role and policy assignments for the subscription. Then add a new resource group, and create a Resource Manager template and role assignment on the new resource group.


1.  Select **All services** in the left pane. Search for and select **Blueprints**.

1.  Select **Blueprint definitions** from the page on the left and select the **+ Create blueprint**
   button at the top of the page.

    Or, select **Create** from the **Getting started** page to go straight to creating a blueprint.

    If prompted, select Start with a blank blueprint.

       ![Screenshot](../Media/Module-2/7d8f3904-0a07-40a6-b58c-53a47122cceb.png)

1.  Provide a **Blueprint name** such as **MyBlueprint**. (Use up to 48 letters and numbers, but no spaces or special characters). Leave **Blueprint description** blank for now.

1.  In the **Definition location** box, select the ellipsis on the right, select your subscription where you want to save the blueprint, and choose **Select**.

1.  Verify that the information is correct. The **Blueprint name** and **Definition location** fields can't be changed later. Then select **Next : Artifacts** at the bottom of the page or the **Artifacts** tab at the top of the page.

1.  Add a role assignment at the subscription level:

   1. Select the **+ Add artifact** row under **Subscription**. The **Add artifact** window opens on
      the right side of the browser.

   1. Select **Role assignment** for **Artifact type**.

   1. Under **Role**, select **Contributor**. Leave the **Add user, app or group** box with the
      check box that indicates a dynamic parameter.

   1. Select **Add** to add this artifact to the blueprint.

      ![Screenshot](../Media/Module-2/c4afe4ee-fbb9-4843-adbe-169eb7af3f78.png)

        **Note**: Most artifacts support parameters. A parameter that's assigned a value during blueprint creation is a *static parameter*. If the parameter is assigned during blueprint assignment, it's a *dynamic parameter*.


1.  Add a policy assignment at the subscription level:

   1. Select the **+ Add artifact** row under the role assignment artifact.

   1. Select **Policy assignment** for **Artifact type**.

   1. Change **Type** to **Built-in**. In **Search**, enter **tag**.

   1. Click out of **Search** for the filtering to occur. Select **Append tag and its value to resource groups**.

   1. Select **Add** to add this artifact to the blueprint.

1.  Select the row of the policy assignment **Append tag and its value to resource groups**.

1.  The window to provide parameters to the artifact as part of the blueprint definition opens and allows setting the parameters for all assignments (static parameters) based on this blueprint instead of during assignment (dynamic parameters). This example uses dynamic parameters during blueprint assignment, so leave the defaults and select **Cancel**.

1.  Add a resource group at the subscription level:

   1. Select the **+ Add artifact** row under **Subscription**.

   1. Select **Resource group** for **Artifact type**.

   1. Leave the **Artifact display name**, **Resource Group Name**, and **Location** boxes blank, but make sure that the check box is checked for each parameter property to make them dynamic parameters.

   1. Select **Add** to add this artifact to the blueprint.

1.  Add a template under the resource group:

   1. Select the **+ Add artifact** row under the **ResourceGroup** entry.

   1. Select **Azure Resource Manager template** for **Artifact type**, set **Artifact display name** to **StorageAccount**, and leave **Description** blank.

   1. On the **Template** tab in the editor box, paste the following Resource Manager template.  After you paste the template, select the **Parameters** tab and note that the template parameters **storageAccountType** and **location** were detected. Each parameter was  automatically detected and populated, but configured as a dynamic parameter.

    ```json
              {
                  "$schema": "https://schema.management.azure.com/schemas/      2015-01-01/deploymentTemplate.json#",
                  "contentVersion": "1.0.0.0",
                  "parameters": {
                      "storageAccountType": {
                          "type": "string",
                          "defaultValue": "Standard_LRS",
                          "allowedValues": [
                              "Standard_LRS",
                              "Standard_GRS",
                              "Standard_ZRS",
                              "Premium_LRS"
                          ],
                          "metadata": {
                              "description": "Storage Account type"
                          }
                      },
                      "location": {
                          "type": "string",
                          "defaultValue": "[resourceGroup().location]",
                          "metadata": {
                              "description": "Location for all resources."
                          }
                      }
                  },
                  "variables": {
                      "storageAccountName": "[concat('store', uniquestring      (resourceGroup().id))]"
                  },
                  "resources": [{
                      "type": "Microsoft.Storage/storageAccounts",
                      "name": "[variables('storageAccountName')]",
                      "location": "[parameters('location')]",
                      "apiVersion": "2018-07-01",
                      "sku": {
                          "name": "[parameters('storageAccountType')]"
                      },
                      "kind": "StorageV2",
                      "properties": {}
                  }],
                  "outputs": {
                      "storageAccountName": {
                          "type": "string",
                          "value": "[variables('storageAccountName')]"
                      }
                  }
              }
    ```

28. Under the Parameters tab, clear the **storageAccountType** check box and note that the drop-down list contains only
      values included in the Resource Manager template under **allowedValues**. Select the box to
      set it back to a dynamic parameter.

1. Select **Add** to add this artifact to the blueprint.

      ![Screenshot](../Media/Module-2/1bcd8780-80c5-4826-a02a-dfba4541583f.png)

1.  Your completed blueprint should look similar to the following. Notice that each artifact has **_x_ out of _y_ parameters populated** in the **Parameters** column. The dynamic parameters are set during each assignment of the blueprint.

       ![Screenshot](../Media/Module-2/822f3257-1fa4-4a80-95e5-912152719ecb.png)

1.  Now that all planned artifacts have been added, select **Save Draft** at the bottom of the page.

### Task 2:  Edit a blueprint


In Create a blueprint, you didn't provide a description or add the role assignment to the new resource group. You can fix both by following these steps:


1.  Select **Blueprint definitions** from the page on the left.

1.  In the list of blueprints, right-click the one that you previously created and select **Edit
   blueprint**.

1.  In **Blueprint description**, provide some information about the blueprint and the artifacts that compose it. In this case, enter something like: **This blueprint sets tag policy and role assignment on the subscription, creates a ResourceGroup, and deploys a resource template and role assignment to that ResourceGroup.**

1.  Select **Next : Artifacts** at the bottom of the page or the **Artifacts** tab at the top of the
   page.

1.  Add a role assignment under the resource group:

   1. Select the **+ Add artifact** row directly under the **ResourceGroup** entry.

   1. Select **Role assignment** for **Artifact type**.

   1. Under **Role**, select **Owner**, and clear the check box under the **Add user, app or group** box.

   1. Search for and select a user, app, or group to add. This artifact uses a static parameter set the same in every assignment of this blueprint.

1. Select **Add** to add this artifact to the blueprint.

   ![Screenshot](../Media/Module-2/d4ef486c-8f45-45d2-800e-80d639ee9b6e.png)

1.  Your completed blueprint should look similar to the following. Notice that the newly added role assignment shows **1 out of 1 parameters populated**. That means it's a static parameter.

       ![Screenshot](../Media/Module-2/9a76e9be-3361-44c0-920d-6eb9274e6aca.png)
   
1.  Select **Save Draft** now that it has been updated.

### Task 3: Publish a blueprint


Now that all the planned artifacts have been added to the blueprint, it's time to publish it. Publishing makes the blueprint available to be assigned to a subscription.


1.  Select **Blueprint definitions** from the page on the left.

1.  In the list of blueprints, right-click the one you previously created and select **Publish
   blueprint**.

1.  In the pane that opens, provide a **Version** (letters, numbers, and hyphens with a maximum length of 20 characters), such as **v1**. Optionally, enter text in **Change notes**, such as **First publish**.

1.  Select **Publish** at the bottom of the page.

### Task 4:  Assign a blueprint


After a blueprint has been published, it can be assigned to a subscription. Assign the blueprint that you created to one of the subscriptions under your management group hierarchy. If the blueprint is saved to a subscription, it can only be assigned to that subscription. 


1.  Select **Blueprint definitions** from the page on the left.

1.  In the list of blueprints, right-click the one that you previously created (or select the ellipsis) and select **Assign blueprint**.

1.  On the **Assign blueprint** page, in the **Subscription** drop-down list, select the subscriptions that you want to deploy this blueprint to.  *Skip this step if you are using an Azure Pass or lab Hoster solution*

       If there are supported Enterprise offerings available from Azure Billing, a Create new link is activated under the Subscription box. Follow these steps:

    a. Select the **Create new** link to create a new subscription instead of selecting existing ones.

    b. Provide a **Display name** for the new subscription.

    c. Select the available **Offer** from the drop-down list.

    d. Use the ellipsis to select the management group that the subscription will be a child of.

    e. Select **Create** at the bottom of the page.

    ![Screenshot](../Media/Module-2/2b2cebe1-4f92-4e72-b583-3d4767cca69b.png)

    **Important**: The new subscription is created immediately after you select **Create**.

    **Note**: An assignment is created for each subscription that you select. You can make changes to a single subscription assignment at a later time without forcing changes on the remainder of the selected subscriptions.


1.  For **Assignment name**, provide a unique name for this assignment.

1.  In **Location**, select a region for the managed identity and subscription deployment object to be created in. Azure Blueprint uses this managed identity to deploy all artifacts in the assigned blueprint. 

1.  Leave the **Blueprint definition version** drop-down selection of **Published** versions on the **v1** entry. (The default is the most recently published version.)

1.  For **Lock Assignment**, leave the default of **Don't Lock**. 

       ![Screenshot](../Media/Module-2/44d5f739-7956-4264-b4e1-bec56a0341db.png)

1.  Under **Managed Identity**, leave the default of **System assigned**.

1.  For the subscription level role assignment **[User group or application name] : Contributor**,  search for and select a user, app, or group.  *You may skip this step if you have no users or groups*

1.  For the subscription level policy assignment, set **Tag Name** to **CostCenter** and the **Tag Value** to **ContosoIT**.

1.  For **ResourceGroup**, provide a **Name** of **StorageAccount** and a **Location** of **East US 2** from the drop-down list.

    **Note**: For each artifact that you added under the resource group during blueprint definition, that artifact is indented to align with the resource group or object that you'll deploy it with.  Artifacts that either don't take parameters or have no parameters to be defined at assignment are listed only for contextual information.


1.  On the Azure Resource Manager template **StorageAccount**, select **Standard_GRS** for the **storageAccountType** parameter.

1.  Read the information box at the bottom of the page, and then select **Assign**.  *Due to the limitations of lab environments you may receive an error.  This can be ignored and continue to the next task*

### Task 5: Track deployment of a blueprint


When a blueprint has been assigned to one or more subscriptions, two things happen:

- The blueprint is added to the **Assigned blueprints** page for each subscription.
- The process of deploying all the artifacts defined by the blueprint begins.

    Now that the blueprint has been assigned to a subscription, verify the progress of the deployment:


1.  Select **Assigned blueprints** from the page on the left.

1.  In the list of blueprints, right-click the one that you previously assigned and select **View
   assignment details**.

       ![Screenshot](../Media/Module-2/03a7cf44-e3da-48e6-a622-f6b03a5752ce.png)

1.  On the **Blueprint assignment** page, validate that all artifacts were successfully deployed and
   that there were no errors during the deployment. If errors occurred, see [Troubleshooting blueprints](./troubleshoot/general.md)
   for steps to determine what went wrong.

### Task 6:  Unassign a blueprint


If you no longer need a blueprint assignment, remove it from a subscription. The blueprint might have been replaced by a newer blueprint with updated patterns, policies, and designs. When a blueprint is removed, the artifacts assigned as part of that blueprint are left behind. To remove a blueprint assignment, follow these steps:


1.  Select **Assigned blueprints** from the page on the left.

1.  In the list of blueprints, select the blueprint that you want to unassign. Then select the
   **Unassign blueprint** button at the top of the page.

1.  Read the confirmation message and then select **OK**.

### Task 6: Delete a blueprint

1.  Select **Blueprint definitions** from the page on the left.

1.  Right-click the blueprint that you want to delete, and select **Delete blueprint**. Then select
   **Yes** in the confirmation dialog box.


**Note**: Deleting a blueprint in this method also deletes all published versions of the selected blueprint. To delete a single version, open the blueprint, select the **Published versions** tab, select the version that you want to delete, and then select **Delete This Version**. Also, you can't delete a blueprint until you've deleted all blueprint assignment of that blueprint definition.


| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |

**Results**: You have now completed this lab.

