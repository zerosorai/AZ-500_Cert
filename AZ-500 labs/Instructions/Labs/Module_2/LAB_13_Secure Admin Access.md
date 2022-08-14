# Module 2 - Implement Platform Protection 

## Lab 13 -  Secure Admin Access 


SSH is an encrypted connection protocol that allows secure sign-ins over unsecured connections. SSH is the default connection protocol for Linux VMs hosted in Azure. Although SSH itself provides an encrypted connection, using passwords with SSH connections still leaves the VM vulnerable to brute-force attacks or guessing of passwords. A more secure and preferred method of connecting to a VM using SSH is by using a public-private key pair, also known as SSH keys.

- The public key is placed on your Linux VM, or any other service that you wish to use with public-key cryptography.

- The private key on you local system is used by an SSH client to verify your identity when you connect to your Linux VM. Protect this private key. Do not share it.

- Depending on your organization's security policies, you can reuse a single public-private key pair to access multiple Azure VMs and services. You do not need a separate pair of keys for each VM or service you wish to access.

Your public key can be shared with anyone, but only you (or your local security infrastructure) should possess your private key.

## Exercise 1: Deploy and connect to an Azure VM securely.

### Task 1: Create SSH keys with PuTTYgen

1.  Open a browser and navigate to the following URL:

    ```cli
    http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html 
    ```

1.  Download and install the **Putty Installer**.

     ![Screenshot](../Media/Module-2/7ad32419-ea65-491b-a7ee-457bf8a378c9.png)

1.  Click **Start** and navigate to **PuTTYgen**.

     ![Screenshot](../Media/Module-2/95f243e9-283c-4358-bce1-560298485904.png)

1.  Click Generate. By default PuTTYgen generates a 2048-bit SSH-2 RSA key.

     ![Screenshot](../Media/Module-2/a6daeb94-87fe-4113-9520-494b24dc4a92.png)

1.  Move the mouse around in the blank area to provide randomness for the key.

     ![Screenshot](../Media/Module-2/6c28f035-a5ba-4246-956a-7baab449d03e.png)

1.  After the public key is generated, optionally enter and confirm a passphrase. You will be prompted for the passphrase when you authenticate to the VM with your private SSH key. Enter **Pa55w.rd1234** as the passphrase.

    Without a passphrase, if someone obtains your private key, they can log in to any VM or service that uses that key. We recommend you create a passphrase. However, if you forget the passphrase, there is no way to recover it.


1.  The public key is displayed at the top of the window. You can copy this entire public key and then paste it into the Azure portal or an Azure Resource Manager template when you create a Linux VM. Save the public key to a location on your machine and call the file **public**:

     ![Screenshot](../Media/Module-2/92e4953d-185b-44c0-942b-4d2eb8b63946.png)

2.  Save the private key to the same location but with the filename **private**.

     ![Screenshot](../Media/Module-2/063a3222-b053-472b-b144-5a57060bb48c.png)
 
1.  Highlight and copy the public key from the top window.

     ![Screenshot](../Media/Module-2/b9d641c5-b0da-412b-a9a2-e3ec98ea5624.png)

### Task 2: Create a Linux virtual machine in the Azure portal

1.  Navigate back to the **Azure Portal**.

1.  Choose **Create a resource** in the upper left corner of the Azure portal.

1.  In the search box above the list of Azure Marketplace resources, search for and select **Ubuntu Server 18.04 LTS** by Canonical, then choose **Create**.

1.  In the **Basics** tab, under **Project details**, make sure the correct subscription is selected and then choose the **Resource group** *myResourceGroup*. 

     ![Screenshot](../Media/Module-2/ed6382e1-5410-4557-b57e-9a0c35816cbb.png)

1.  Under **Instance details**, type *myVM-Linux* for the **Virtual machine name** and choose *East US* for your **Region**. Leave the other defaults.
 
     ![Screenshot](../Media/Module-2/0761733a-5161-437e-a565-6a1600f50c02.png)

1.  Under **Administrator account**, select **SSH public key**, type the user name **localadmin**, then paste your public key into the text box. Remove any leading or trailing white space in your public key.

       ![Screenshot](../Media/Module-2/3ebdb60b-112b-4f03-81d3-6069eec7cdc2.png)

1.  Under **Inbound port rules** > **Public inbound ports**, choose **Allow selected ports** and then select **SSH (22)** and **HTTP (80)** from the drop-down. 

    ![Screenshot](../Media/Module-2/8e7941c5-3e05-4027-accb-a955ff895eb0.png)

1.  Click the **Management** tab and select **No** or **Off** for all options.

     ![Screenshot](../Media/Module-2/d1da9d2c-3fa3-488a-9f8a-034f33a93071.png)

1.  Leave the remaining defaults and then select the **Review + create** button at the bottom of the page.

1.  On the **Create a virtual machine** page, you can see the details about the VM you are about to create. When you are ready, select **Create**.

     ![Screenshot](../Media/Module-2/3107832c-c18a-451a-bdae-01537c4f54c5.png)
 

It will take a few minutes for your VM to be deployed. When the deployment is finished, move on to the next section. 



### Task 3: Connect to your VM


One way to make an SSH connection to your Linux VM from Windows is to use an SSH client. This is the preferred method if you have an SSH client installed on your Windows system, or if you use the SSH tools in Bash in Azure Cloud Shell. If you prefer a GUI-based tool, you can connect with PuTTY.  In this task you will use PuTTY.


1.  In the **Azure Portal Hub Menu** click **Virtual Machines** then select your **myVM-Linux** machine.


1.  In the Overview blade, note down or copy the **Public IP Address** of your virtual machine *If this does not display, refresh your browser*.

    **Note:** Your public IP will be different to what is shown in the screenshot.


     ![Screenshot](../Media/Module-2/e924600c-9a1a-4ba9-a74a-5ff7b4ac10cf.png)

1.  Start **PuTTy** by clicking the start menu and searching for PuTTY.

     ![Screenshot](../Media/Module-2/be5cc422-5053-4df2-864a-bfe2078aa57c.png)

2.  Type in or paste in your Public IP Address of your Linux Azure Linux VM:

       ![Screenshot](../Media/Module-2/d84a12b3-103a-4905-8989-532731fa89ff.png)

3.  Select the **Connection** > **SSH** > **Auth** category. Browse to and select your PuTTY private key (.ppk file):

     ![Screenshot](../Media/Module-2/528ddd44-ddb7-4a34-8235-34fdc1f70410.png)

4.  Click **Open** to connect to your VM.

5.  Click **Yes** to continue on the pop up.

1.  On the `login as` screen enter **localadmin** and press **Enter** then enter the password Pa55w.rd1234 and press **Enter**. ***Note**: As you type the password the curser will not move*

     ![Screenshot](../Media/Module-2/57d91a3f-eee7-4acb-8c90-696c826102d5.png)
 
2.  You are now logged into the Linux VM hosted in Azure.

     ![Screenshot](../Media/Module-2/d79b17ca-2036-4ef8-8063-15b442cabb9a.png)

| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |

**Results**: You have now completed this Lab.
