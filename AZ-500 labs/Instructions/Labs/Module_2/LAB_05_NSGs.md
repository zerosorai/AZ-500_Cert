# Module 2: Lab 5 - NSGs


You can filter network traffic inbound to and outbound from a virtual network subnet with a network security group. Network security groups contain security rules that filter network traffic by IP address, port, and protocol. Security rules are applied to resources deployed in a subnet. In this tutorial, you learn how to:

- Create a network security group and security rules
- Create a virtual network and associate a network security group to a subnet
- Deploy virtual machines (VM) into a subnet
- Test traffic filters


## Exercise 1: Filter network traffic with a network security group using the Azure portal

### Task 1:  Create a virtual network

1.  Select **+ Create a resource** on the upper left corner of the Azure portal.
2.  Select **Networking**, and then select **Virtual network**.
3.  Enter, or select, the following information, accept the defaults for the remaining settings, and then select **Review + create**, then click **Create**:

    | Setting                 | Value                                              |
    | ---                     | ---                                                |
    | Name                    | myVirtualNetwork                                   |
    | Subscription            | Select your subscription.                          |
    | Resource group          | Select **Create new** and enter *myResourceGroup*. |
    | Location                | Select **East US**.                                |

    Select the IP Addresses tab and enter the following values:

    | Setting                 | Value                                              |
    | ---                     | --- |
    | Address space           | 10.0.0.0/16                                        |
    | Subnet- Name            | Change the default subnet name to **mySubnet** and click **Save**                                           |
    | Subnet - Address range  | 10.0.0.0/24                                        |

### Task 2:  Create application security groups


An application security group enables you to group together servers with similar functions, such as web servers.


1.  Select **+ Create a resource** on the upper left corner of the Azure portal.
2.  In the **Search the Marketplace** box, enter *Application security group*. When **Application security group** appears in the search results, select it, select **Application security group** again under **Everything**, and then select **Create**.
3.  Enter, or select, the following information, and then select **Create**:

    | Setting        | Value                                                         |
    | ---            | ---                                                           |
    | Name           | myAsgWebServers                                               |
    | Subscription   | Select your subscription.                                     |
    | Resource group | Select **Use existing** and then select  **myResourceGroup**. |
    | Location       | East US                                                       |

4.  Complete step 3 again, specifying the following values:

    | Setting        | Value                                                         |
    | ---            | ---                                                           |
    | Name           | myAsgMgmtServers                                              |
    | Subscription   | Select your subscription.                                     |
    | Resource group | Select **Use existing** and then select  **myResourceGroup**. |
    | Location       | East US                                                       |

### Task 3:  Create a network security group

1.  Select **+ Create a resource** on the upper left corner of the Azure portal.
2.  Select **Networking**, and then select **Network security group**.
3.  Enter, or select, the following information, and then select **Create**:

    |Setting|Value|
    |---|---|
    |Name|myNsg|
    |Subscription| Select your subscription.|
    |Resource group | Select **Use existing** and then select *myResourceGroup*.|
    |Location|East US|

### Task 4:  Associate network security group to subnet

1.  In the *Search resources, services, and docs* box at the top of the portal, begin typing *myNsg*. When **myNsg** appears in the search results, select it.
2.  Under **SETTINGS**, select **Subnets** and then select **+ Associate**. 

3.  Under **Associate subnet**, select **Virtual network** and then select **myVirtualNetwork**. Select **Subnet**, select **mySubnet**, and then select **OK**.

### Task 5:  Create security rules

1.  Under **SETTINGS**, select **Inbound security rules** and then select **+ Add**.

2.  Create a security rule that allows ports 80 and 443 to the **myAsgWebServers** application security group. Under **Add inbound security rule**, enter, or select the following values, accept the remaining defaults, and then select **Add**:

    | Setting                 | Value                                                                                                           |
    | ---------               | ---------                                                                                                       |
    | Destination             | Select **Application security group**, and then select **myAsgWebServers** for **Application security group**.  |
    | Destination port ranges | Enter 80,443                                                                                                    |
    | Protocol                | Select TCP                                                                                                      |
    | Name                    | Allow-Web-All                                                                                                   |

3.  Complete step 2 again, using the following values:

    | Setting                 | Value                                                                                                           |
    | ---------               | ---------                                                                                                       |
    | Destination             | Select **Application security group**, and then select **myAsgMgmtServers** for **Application security group**. |
    | Destination port ranges | Enter 3389                                                                                                      |
    | Protocol                | Select TCP                                                                                                      |
    | Priority                | Enter 110                                                                                                       |
    | Name                    | Allow-RDP-All                                                                                                   |

    In this tutorial, RDP (port 3389) is exposed to the internet for the VM that is assigned to the *myAsgMgmtServers* application security group. For production environments, instead of exposing port 3389 to the internet, it's recommended that you connect to Azure resources that you want to manage using a VPN or private network connection.


### Task 6:  Create virtual machines

1.  Select **+ Create a resource** found on the upper left corner of the Azure portal.
2.  Select **Compute**, and then select **Windows Server 2016 Datacenter**.
3.  Enter, or select, the following information, and accept the defaults for the remaining settings:

    |Setting|Value|
    |---|---|
    |Subscription| Select your subscription.|
    |Resource group| Select **Use existing** and select **myResourceGroup**.|
    |Name|myVmWeb|
    |Location| Select **East US**.|
    |User name| Enter a user name of your choosing.|
    |Password| Pa55w.rd1234 |

   

4.  Select a size for the VM and then select **Select**.
5.  Under **Networking**, select the following values, and accept the remaining defaults:

    |Setting|Value|
    |---|---|
    |Virtual network |Select **myVirtualNetwork**.|
    |NIC network security group |Select **None**.|

6.  Under **Management**, select **Off** for **Boot diagnostics**.  
7.  Select **Review + Create** at the bottom left corner, select **Create** to start VM deployment.

### Task 7:  Create the second VM

Complete above steps 1-7 again, but in step 3, name the VM *myVmMgmt*. The VM takes a few minutes to deploy. Do not continue to the next step until the VM is deployed.

### Task 8:  Associate network interfaces to an ASG


When the portal created the VMs, it created a network interface for each VM and attached the network interface to the VM. Add the network interface for each VM to one of the application security groups you created previously:


1.  In the *Search resources, services, and docs* box at the top of the portal, begin typing *myVmWeb*. When the **myVmWeb** VM appears in the search results, select it.
2.  Under **SETTINGS**, select **Networking**.  Select **Application security groups**, then **Configure the application security groups**, then select **myAsgWebServers** for **Application security groups**, and then select **Save**.

3.  Complete steps 1 and 2 again, searching for the **myVmMgmt** VM and selecting the  **myAsgMgmtServers** ASG.

### Task 9:  Test traffic filters

1.  Connect to the *myVmMgmt* VM. Enter *myVmMgmt* in the search box at the top of the portal. When **myVmMgmt** appears in the search results, select it. Select the **Connect** button.
2.  Select **RDP**, then **Download RDP file**.
3.  Open the downloaded rdp file and select **Connect**. Enter the user name and password you specified when creating the VM. You may need to select **More choices**, then **Use a different account**, to specify the credentials you entered when you created the VM.
4.  Select **OK**.
5.  You may receive a certificate warning during the sign-in process. If you receive the warning, select **Yes** or **Continue** to proceed with the connection.

    The connection succeeds because port 3389 is allowed inbound from the internet to the *myAsgMgmtServers* application security group that the network interface attached to the *myVmMgmt* VM is in.

6.  Connect to the *myVmWeb* VM from the *myVmMgmt* VM by entering the following command in a PowerShell session:

    ```powershell
    mstsc /v:myVmWeb
    ```

    You are able to connect to the myVmWeb VM from the myVmMgmt VM because VMs in the same virtual network can communicate with each other over any port, by default. You can't, however, create a remote desktop connection to the *myVmWeb* VM from the internet because the security rule for the *myAsgWebServers* doesn't allow port 3389 inbound from the internet, and inbound traffic from the Internet is denied to all resources, by default.

7.  To install Microsoft IIS on the *myVmWeb* VM, enter the following command from a PowerShell session on the *myVmWeb* VM:

    ```powershell
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    ```

8.  After the IIS installation is complete, disconnect from the *myVmWeb* VM, which leaves you in the *myVmMgmt* VM remote desktop connection.
9.  Disconnect from the *myVmMgmt* VM.
10.  In the *Search resources, services, and docs* box at the top of the Azure portal, begin typing *myVmWeb* from your computer. When **myVmWeb** appears in the search results, select it. Note the **Public IP address** for your VM. The address shown in the following picture is 137.135.84.74, but your address is different:

       ![Screenshot](../Media/Module-2/e3bbd69d-95d0-4b3b-98ce-714d30b4d1ef.png)
  
11.  To confirm that you can access the *myVmWeb* web server from the internet, open an internet browser on your computer and browse to `http://<public-ip-address-from-previous-step>`. You see the IIS welcome screen because port 80 is allowed inbound from the internet to the *myAsgWebServers* application security group that the network interface attached to the *myVmWeb* VM is in.


| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |

**Results**: You have now completed this lab.
