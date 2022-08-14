# Module 2: Lab 4 - Create a VNet


**Scenario**

In this module, you'll will be introduced to Azure virtual networks. What are virtual networks and how are they organized? How do you create and configure virtual networks with templates, PowerShell, CLI, or the Azure portal? What is the difference between public, private, static, and dynamic IP addressing? How are system routes, routing tables, and routing algorithms used? Lessons include:

- Introducing Virtual Networks
- Creating Azure Virtual Networks
- Review of IP Addressing


## Exercise 1: Create a virtual network using the Azure portal


**Scenario**

A virtual network is the fundamental building block for your private network in Azure. It enables Azure resources, like virtual machines (VMs), to securely communicate with each other and with the internet. In this lab, you will learn how to create a virtual network using the Azure portal. Then, you can deploy two VMs into the virtual network, securely communicate between the two VMs, and connect to the VMs from the internet.


### Task 1: Create a virtual network

1.  On the upper-left side of the screen, select **Create a resource** > **Networking** > **Virtual network**.

1.  In **Create virtual network**, enter or select this information:

    | Setting | Value |
    | ------- | ----- |
    | Subscription | Select your subscription.|
    | Resource group | Select **Create new**, enter *myResourceGroup*, then select **OK**. |
    | Name | Enter *myVirtualNetwork*. |
    | Location | Select **East US**.|

    Select the IP Addresses tab and enter the following values:

    | Setting | Value |
    | ------- | ----- |
    | Address space | Enter *10.1.0.0/16*. |
    | Subnet - Name | Enter *myVirtualSubnet*. |
    | Subnet - Address range | Enter *10.1.0.0/24*. |

1.  Leave the rest as default and select **Review + create**, then click **Create**.

### Task 2: Create virtual machines


Create two VMs in the virtual network:


1.  On the upper-left side of the screen, select **Create a resource** > **Compute** > **Virtual machine**.

1.  In **Create a virtual machine - Basics**, enter or select this information:

    | Setting | Value |
    | ------- | ----- |
    | **PROJECT DETAILS** | |
    | Subscription | Select your subscription. |
    | Resource group | Select **myResourceGroup**. You created this in the previous section. |
    | **INSTANCE DETAILS** |  |
    | Virtual machine name | Enter *myVm1*. |
    | Region | Select **East US**. |
    | Availability options | Leave the default **No infrastructure redundancy required**. |
    | Image | Select **Windows Server 2019 Datacenter**. |
    | Size | Select **Standard DS1 v2**. |
    | **ADMINISTRATOR ACCOUNT** |  |
    | Username | Enter a username of your choosing. |
    | Password | Pa55w.rd1234 |
    | Confirm Password | Reenter password. |
    | **INBOUND PORT RULES** |  |
    | Public inbound ports | Select **Allow selected ports**. |
    | Select inbound ports | Select **HTTP** and **RDP**.
    | **SAVE MONEY** |  |
    | Already have a Windows license? | Leave the default **No**. |

1.  Select **Next : Disks**.

1.  In **Create a virtual machine - Disks**, leave the defaults and select **Next : Networking**.

1.  In **Create a virtual machine - Networking**, select this information:

    | Setting | Value |
    | ------- | ----- |
    | Virtual network | Leave the default **myVirtualNetwork**. |
    | Subnet | Leave the default **myVirtualSubnet (10.1.0.0/24)**. |
    | Public IP | Leave the default **(new) myVm1-ip**. |
   

1.  Select **Next : Management**.

1.  In **Create a virtual machine - Management**, for **Diagnostics storage account**, select **Create New**.

1.  In **Create storage account**, enter or select this information:

    | Setting | Value |
    | ------- | ----- |
    | Name | Enter *myvmstorageaccount*. If this name is taken, create a unique name.|
    | Account kind | Leave the default **Storage (general purpose v1)**. |
    | Performance | Leave the default **Standard**. |
    | Replication | Leave the default **Locally-redundant storage (LRS)**. |

1.  Select **OK**

1.  Select **Review + create**. You're taken to the **Review + create** page where Azure validates your configuration.

1.  When you see the **Validation passed** message, select **Create**.

### Task 3:  Create the second VM

1.  Complete steps 1 and 9 from above.

    **Note**: In step 2, for the **Virtual machine name**, enter *myVm2*.  In step 7, for **Diagnosis storage account**, make sure you select **myvmstorageaccount**.


1.  Select **Review + create**. You're taken to the **Review + create** page and Azure validates your configuration.

1.  When you see the **Validation passed** message, select **Create**.

### Task 4:  Connect to a VM from the internet


After you've created *myVm1*, connect to the internet.


1.  In the portal's search bar, enter *myVm1*.

1.  Select the **Connect** button.

1.  Select **RDP**, then **Download RDP File**. Azure creates a Remote Desktop Protocol (*.rdp*) file and downloads it to your computer.

1.  Open the downloaded *.rdp* file.

    1. If prompted, select **Connect**.

    1. Enter the username and password you specified when creating the VM.

    **Note**: You may need to select **More choices** > **Use a different account**, to specify the credentials you entered when you created the VM.


1.  Select **OK**.

1.  You may receive a certificate warning during the sign in process. If you receive a certificate warning, select **Yes** or **Continue**.

### Task 5: Communicate between VMs

1.  In the Remote Desktop of *myVm1*, open PowerShell.

1.  Enter `ping myVm2`

    You'll receive a message similar to this:

    ```powershell
    Pinging myVm2.0v0zze1s0uiedpvtxz5z0r0cxg.bx.internal.clouda
    Request timed out.
    Request timed out.
    Request timed out.
    Request timed out.

    Ping statistics for 10.1.0.5:
    Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),
    ```

    The `ping` fails because `ping` uses the Internet Control Message Protocol (ICMP). By default, ICMP isn't allowed through the Windows firewall.

1.  To allow *myVm2* to ping *myVm1* in a later step, enter this command:

    ```powershell
    New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4
    ```

    This command allows ICMP inbound through the Windows firewall:

1.  Close the remote desktop connection to *myVm1*.

1.  Complete the steps in **Connect to a VM from the internet** task again, but connect to *myVm2*.

1.  From a command prompt, enter `ping myvm1`.

    You'll get back something like this message:

    ```powershell
    Pinging myVm1.0v0zze1s0uiedpvtxz5z0r0cxg.bx.internal.cloudapp.net [10.1.0.4] with 32 bytes of data:
    Reply from 10.1.0.4: bytes=32 time=1ms TTL=128
    Reply from 10.1.0.4: bytes=32 time<1ms TTL=128
    Reply from 10.1.0.4: bytes=32 time<1ms TTL=128
    Reply from 10.1.0.4: bytes=32 time<1ms TTL=128

    Ping statistics for 10.1.0.4:
        Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
    Approximate round trip times in milli-seconds:
        Minimum = 0ms, Maximum = 1ms, Average = 0ms
    ```

    You receive replies from *myVm1* because you allowed ICMP through the Windows firewall on the *myVm1* VM in step 3.

1.  Close the remote desktop connection to *myVm2*.


| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |

**Results**: You have now completed this lab.
