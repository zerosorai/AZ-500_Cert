# Module 2: Lab 1 - Monitor & Autoscale


Autoscale is a built-in feature of Cloud Services, Mobile Services, Virtual Machines, and Websites that helps applications perform their best when demand changes. Of course, performance means different things for different applications. Some apps are CPU-bound, others memory-bound. For example, you could have a web app that handles millions of requests during the day and none at night. Autoscale can scale your service by any of these-or by a custom metric you define.


## Exercise 1: Lab setup

1.  Go to the following URL in the browser:

    https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftLearning%2FAZ-500-Azure-Security%2Fmaster%2FAllfiles%2FLabs%2FMod2_Lab01%2Ftemplate.json


    *This will deploy a new app and app service plan from a template that can then be used to demonstrate the scale up options in AZ500 Mod2 Lab 1.*

1.  Select **Create a new Resource Group**  

1.  Type a **unique** name for the **Site Name** and **Service Plan**. 

1.  Agree to the terms and click **Purchase**

## Exercise 2: Create your first Autoscale setting


Let's now go through a simple step-by-step walkthrough to create your first Autoscale setting.


1.  Open the **Autoscale** blade in Azure Monitor and select a resource that you want to scale. You can select the app service plan that you created during the setup
1.  Note that the current instance count is 1. Click **Custom autoscale**.

1.  Provide a name for the scale setting, and then click **Add a rule**. 

1.  Notice the scale rule options that open as a context pane on the right side. By default, this sets the option to scale your instance count by 1 if the CPU percentage of the resource exceeds 70 percent. Leave it at its default values and click **Add**.

1.  You've now created your first scale rule. Note that the UI recommends best practices and states that "It is recommended to have at least one scale in rule." To do so:

    - Click **Add a rule**.

    - Set **Operator** to **Less than**.

    - Set **Threshold** to **20**.

    - Set **Operation** to **Decrease count by**.

1.  Click **Add**

1.  Click **Save**.

    **Note**:   If you receive an error "Microsoft.insights not registered" (Add button grayed out) go to your Subscription blade and under Resource Providers register "Microsoft.insights" and wait a few minutes for registration then retry. If it does not register, continue to to the next exercise.


**Congratulations**! You've now successfully created your first scale setting to autoscale your web app based on CPU usage.


## Exercise 3: Scale based on a schedule


In addition to scale based on CPU, you can set your scale differently for specific days of the week.


1.  Click **Add a scale condition**.

1.  Setting the scale mode and the rules is the same as the default condition.
1.  Select **Repeat specific days** for the schedule.
1.  Select the days and the start/end time for when the scale condition should be applied.


## Exercise 4: Scale differently on specific dates


In addition to scale based on CPU, you can set your scale differently for specific dates.


1.  Click **Add a scale condition**.

1.  Setting the scale mode and the rules is the same as the default condition.
1.  Select **Specify start/end dates** for the schedule.
1.  Select the start/end dates and the start/end time for when the scale condition should be applied.  Click **Save**.



## Exercise 5:  View the scale history of your resource

1.  Whenever your resource is scaled up or down, an event is logged in the activity log. You can view the scale history of your resource for the past 24 hours by switching to the **Run history** tab.

1.  If you want to view the complete scale history (for up to 90 days), select **View more details in the Activity Log**. The activity log opens, with Autoscale pre-selected for your resource and category.

## Exercise 6: View the scale definition of your resource

1.  Autoscale is an Azure Resource Manager resource. You can view the scale definition in JSON by switching to the **JSON** tab.

1.  You can make changes in **JSON** directly, if required. These changes will be reflected after you save them.


| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |


**Results**: You have now completed this lab.
