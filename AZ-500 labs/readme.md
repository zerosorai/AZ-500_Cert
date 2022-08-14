# AZ-500 Azure Security (old)

**A new version of AZ-500 was released 17 July There is a new lab repository to go with the content update - AZ500X-AzureSecurityTechnologies. Please move to this new version of the course and labs.**

- **Are you a MCT?** - Have a look at our [GitHub User Guide for MCTs](https://microsoftlearning.github.io/MCT-User-Guide/)
- **Need to manually build the lab instructions?** - Instructions are available in the [MicrosoftLearning/Docker-Build](https://github.com/MicrosoftLearning/Docker-Build) repository

> Be sure to use the [MCT Courseware Forum](https://www.microsoft.com/en-us/learning/mct-central.aspx) for suggestions or general comments on the course content. Also, bugs and course errors can be reported on the [Courseware Support Forum](https://trainingsupport.microsoft.com/en-us).
 
To support the new changes, we introduced a new AZ-500 GitHub repository, starting on November 1 2019. At that time, all the AZ-500 labs have been replaced with this repository.

**What are we doing?**

*	We are publishing the lab instructions and lab files on GitHub to allow for interaction between the course authors and MCTs. We hope this will help  keep the content current as the Azure platform changes.

*	This is an old GitHub repository for the AZ-500, Microsoft Azure Security course. 

*	Within each repository there are lab guides in the Markdown format in the Instructions folder. If appropriate, there are also additional files that are needed to complete the lab within the Allfiles\Labfiles folder. Not every course has corresponding lab files. 

*	For each delivery, trainers should download the latest files from GitHub. Trainers should also check the Issues tab to see if other MCTs have reported any errors.  

*	Lab timing estimates are provided but trainers should check to ensure this is accurate based on the audience.

*	To do the labs you will need an internet connection and an Azure subscription. Please read the Instructor Prep Guide for more information on using the Cloud Shell. 

**How are we doing?**

*	If as you are teaching these courses, you identify areas for improvement, please use the Issues tab to provide feedback. We will periodically create new files to incorporate the changes. 


* When launching Azure Cloud Shell for the first time, you will likely be prompted to create an Azure file share to persist Cloud Shell files. If so, you can typically accept the defaults, which will result in creation of a storage account in an automatically generated resource group. Note that this might happen again if you delete that storage account.

* Before you perform a template based deployments, you might need to register providers that handle provisioning of resource types referenced in the template. This is a one-time operation (per subscription) required when using Azure Resource Manager templates to deploy resources managed by these resource providers (if these resource providers have not been yet registered). You can perform registration from the subscription's Resource Providers blade in the Azure portal or by using Cloud Shell to run Register-AzResourceProvider PowerShell cmdlet or az provider Azure CLI command.

We hope using this GitHub repository brings a sense of collaboration to the labs and improves the overall quality of the lab experience. 

Regards,
*Azure Security Courseware Team*
