# Module 2: Lab 10 - Load Balancer


**Scenario**

In this module, you will learn about three ways to distribute network traffic: Azure Load Balancer, Azure Traffic Manager, and Azure Application Gateway. The Azure Load Balancer delivers high availability and network performance to your applications. The Azure Traffic Manager allows you to control the distribution of user traffic to your service endpoints. The Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to your web applications. 

**Lessons include:**

- Azure Load Balancer
- Azure Traffic Manager 
- Azure Application Gateway


## Exercise 1: Distributing Network Traffic using a Standard Load Balancer


In this section, you create a public load balancer that helps load balance virtual machines. Standard Load Balancer only supports a Standard Public IP address. When you create a Standard Load Balancer, and you must also create a new Standard Public IP address that is configured as the frontend (named as *LoadBalancerFrontend* by default) for the Standard Load Balancer. 


### Task 1: Create a public load balancer

1.  On the top left-hand side of the screen, click **Create a resource** > **Networking** > **Load Balancer**.  

2.  In the **Create load balancer** page, enter or select the following information, accept the defaults for the remaining settings, and then select **Review + create**:

    | Setting                 | Value                                              |
    | ---                     | ---                                                |
    | Subscription               | Select your subscription.    |
    |Resource group | Select **Create new**, and then type myResourceGroupLB    |
    | Name                   | *myLoadBalancer*                                   |
    | Region           | Select **East US**.                          |
    | Type          | Public                                        |
    | SKU           | Standard                          |
    | Public IP address | Select **Create new** and type *myPublicIP* in the name box.  |
    | Availability zone               | **Zone-redundant**    |
    
      ![Screenshot](../Media/Module-2/23a57ee6-db41-4259-a6a8-6a0ae782487e.png)

1.  On the Validation screen click **Create**.

### Task 2: Create a virtual network

1.  On the top left-hand side of the screen click **+ Create a resource** > **Networking** > **Virtual network** and enter these values for the virtual network:
    - **myVnet** - for the name of the virtual network.
    - **myResourceGroupLB** - for the name of the existing resource group

    
    Select the IP Addresses tab and enter the following values:
    
    - **10.0.0.0/16** - for the Address space
    - **myBackendSubnet** - for the subnet name.
    - **10.0.0.0/24** - for the Subnet Address range
    </br>

2.  Click **Review + create**, then click **Create** to create the virtual network.

### Task 3: Create virtual machines

1.  On the top left-hand side of the screen, click **Create a resource** > **Compute** > **Virtual Machine** and enter these values for the virtual machine:
          
    - **myResourceGroupLB** - for **Resource group**, select *myResourceGroupLB* from the drop down menu.
    - **myVM1** - for the name of the virtual machine.  
    - **Image** - Windows Server 2019 Datacenter.
    - **localadmin** - for the **Username**
    - **Pa55w.rd1234** - for the **Password**
    - **HTTP (80) & RDP (3389)** - for the inbound port rules.
    </br>

     ![Screenshot](../Media/Module-2/72f0ebb7-0fa5-4425-a137-a7c6773bc2e0.png)

1.  Click the Networking Tab and under Public IP click **Create new**.  Name the IP Address **myPIP1** and click the **Standard SKU** then click **OK**.

    **Note**: If you do not select the Standard SKU here you will have problems later in the lab.


     ![Screenshot](../Media/Module-2/3ffe8457-67c1-4da1-98dc-e4f864889e74.png)

2.  Select the **Management** Tab and ensure all radio buttons are **No** or **Off**.

1.  Click **Review + create** then click **Create**.

7.  Repeat the steps above to create a second VM, called ***myVM2*** using _**myPIP2**_ for the new Public IP address. 
 
### Task 4: Install IIS

1.  Click **All resources** in the left-hand menu, and then from the resources list click **myVM1** that is located in the *myResourceGroupLB* resource group.

2.  On the **Overview** page, click **Connect** to RDP into the VM.
3.  Log into the VM with username *localadmin*.
4.  Open PowerShell and run the following command to install IIS.

    ```powershell
    Install-WindowsFeature Web-Server
    ```

7.  Repeat steps 1 to 4 for the virtual machine *myVM2*.

### Task 5: Create load balancer resources


In this section, you  configure load balancer settings for a backend address pool and a health probe, and specify a load balancer rule.

To distribute traffic to the VMs, a backend address pool contains the IP addresses of the virtual (NICs) connected to the load balancer. Create the backend address pool *myBackendPool* to include *VM1* and *VM2*.


1.  Click **All resources** in the left-hand menu, and then click **myLoadBalancer** from the resources list.

2.  Under **Settings**, click **Backend pools**, then click **Add**.

     ![Screenshot](../Media/Module-2/136599df-622d-4ed4-8f53-616a18ff6dde.png)

3.  On the **Add a backend pool** page, do the following:
   - For name, type *myBackendPool*, as the name for your backend pool.
   - For **Virtual network**, select *myVNet*.
   - Add *myVM1* and *my VM2* under **Virtual Machine** along with their corresponding IP addresses, and then select **Add**.
     </br>
 
     ![Screenshot](../Media/Module-2/5133a39e-32e7-4ea4-9067-042086c75ab9.png)

3.  Check to make sure your load balancer backend pool setting displays both the VMs **VM1** and **VM2**.

     ![Screenshot](../Media/Module-2/2d31782e-a552-4b32-919a-1ac2d8a5d2ef.png)

### Task 6: Create a health probe


To allow the load balancer to monitor the status of your app, you use a health probe. The health probe dynamically adds or removes VMs from the load balancer rotation based on their response to health checks. Create a health probe *myHealthProbe* to monitor the health of the VMs.


1.  On the Load Balancer blade, under **Settings**, click **Health probes**, then click **Add**.

     ![Screenshot](../Media/Module-2/ed2916af-c8d1-4dbf-89b0-4ec1882d8895.png)

3.  Use these values to create the health probe:
    - *myHealthProbe* - for the name of the health probe.
    - **HTTP** - for the protocol type.
    - *80* - for the port number.
    - */* - for the URI path. 
    - *15* - for number of **Interval** in seconds between probe attempts.
    - *2* - for number of **Unhealthy threshold** or consecutive probe failures that must occur before a VM is considered unhealthy.
    </br>
 
     ![Screenshot](../Media/Module-2/1a1ff476-8400-4e05-89bc-228531f41c80.png)


4.  Click **OK**.


### Task 7: Create a load balancer rule


A load balancer rule is used to define how traffic is distributed to the VMs. You define the frontend IP configuration for the incoming traffic and the backend IP pool to receive the traffic, along with the required source and destination port. Create a load balancer rule *myLoadBalancerRuleWeb* for listening to port 80 in the frontend *FrontendLoadBalancer* and sending load-balanced network traffic to the backend address pool *myBackEndPool* also using port 80. 


1.  On the Load Balancer blade, under **Settings**, click **Load balancing rules**, then click **Add**.

     ![Screenshot](../Media/Module-2/00905851-76d6-428e-81aa-967797246767.png)


3.  Use these values to configure the load balancing rule:
    - *myHTTPRule* - for the name of the load balancing rule.
    - **TCP** - for the protocol type.
    - *80* - for the port number.
    - *80* - for the backend port.
    - *myBackendPool* - for the name of the backend pool.
    - *myHealthProbe* - for the name of the health probe.
    </br>
    
      ![Screenshot](../Media/Module-2/61e544c5-931d-4b5c-90f1-6e9cfbe003ec.png)
    
4.  Click **OK**.
    
### Task 8: Test the load balancer

1.  Find the public IP address for the Load Balancer on the **Overview** screen.

     ![Screenshot](../Media/Module-2/f6453cb7-3514-4f7d-97ca-1a480c6791c9.png)
  
2.  Copy the public IP address, and then paste it into the address bar of your browser. The default page of IIS Web server is displayed on the browser.

     ![Screenshot](https://godeployblob.blob.core.windows.net//labguideimages/AZ-300T02/Module-3/1b9f9311-3c0a-4948-be50-2753793daafc.png)

1.  Notice the IIS default page loads.

1.  In the Azure Portal click on **Virtual Machines** in the hub menu.  Select myVM1 and in the **Overview** blade click **Stop** and confirm **Yes**.

     ![Screenshot](../Media/Module-2/31aadf1a-90a8-4c4a-8a78-522d8b506832.png)
 
1.  Wait until the myVM1 Virtual Machine has stopped then go back to the browser tab with the load lanancer public IP and click refresh to confirm myVM2 is continuing to service the requests and the load balancer is functioning as expected.

## Exercise 2:  Load Balancer ARM Deployments

### Task 1: Deploy an ARM template 


This template allows you to create 2 Virtual Machines under a Load balancer and configure a load balancing rule on Port 80. This template also deploys a Storage Account, Virtual Network, Public IP address, Availability Set and Network Interfaces. In this template, we use the resource loops capability to create the network interfaces and virtual machines


1.  In a new tab in your browser, navigate to the following URL **`https://aka.gd/2E2MAjh`**

1.  Click **Deploy to Azure**

     ![Screenshot](../Media/Module-2/81169024-6590a280-8f98-11ea-8688-c4bb5f4fc479.png)

1.  On the template blade that opens, enter the following details:

      - Resource group:  **myResourceGroupLB**
      - Admin Username:  **localadmin**
      - Admin Password:  **Pa55w.rd1234**

1.  Click **I agree....** and click **Purchase**.
# Exercise 3: Deploying Application Gateways

### Task 1: Create an application gateway


A virtual network is needed for communication between the resources that you create. Two subnets are created in this example: one for the application gateway, and the other for the backend servers. You can create a virtual network at the same time that you create the application gateway.


1.  First you need to create a subnet for the Application Gateway to reside in.  Click **Virtual networks** on hub menu and select **myVNet**.

     ![Screenshot](../Media/Module-2/0c72b829-810a-464d-838f-8b400441a789.png)
 
1.  Click **Subnets** and click **+ Subnet**.

     ![Screenshot](../Media/Module-2/598ede38-6ffb-4a65-ac2e-dced9f3b8659.png)
 
1.  Enter **myAppGWSubnet** as the name and click **OK**.

     ![Screenshot](../Media/Module-2/b190cb3f-c689-4051-b70b-a48c5ff11b5e.png)

1.  Click **Create a resource** found on the upper left-hand corner of the Azure portal.

2.  Click **Networking** and then click **Application Gateway** in the Featured list.

     ![Screenshot](../Media/Module-2/cb137e4f-fdd6-49bb-afe0-618e01521969.png)

1.  Enter these values for the application gateway basics blade then click **Next**:

    - *myAppGateway* - for the name of the application gateway.
    - *myResourceGroupLB* - select the already existing Resource Group.
    - *myVnet* - select the already existing Virtual network.
      </br>
    
      ![Screenshot](../Media/Module-2/a2dc825b-ddfe-4ff5-aa0a-fdd832ba9b81.png)

7.  Under **Frontend configuration** blade, ensure **IP address type** is set to **public**, and under **Public IP address**, click **Create new**. Type ***myAGPublicIPAddress*** for the public IP address name and then click **OK**.

     ![Screenshot](../Media/Module-2/6c25478d-d4a2-477a-8b6b-bc07ca78fd3c.png)
 
1. Click **Next**.

1. Select **+Add a backend pool**.

1. Enter the name **appGatewayBackendPool**.  Under backend targets select **Virtual Machine** and add myVM1 and myVM2 virtual machines and their associated network interfaces then click **Add**.

     ![Screenshot](../Media/Module-2/24a1e6f0-fad1-4bee-8372-dceed434b220.png)

1. Click **Next**.

1. On the **Configuration** tab, you'll connect the frontend and backend pool you created using a routing rule.

1. Select **Add a rule** in the **Routing rules** column.

2. In the **Add a routing rule** window that opens, enter *myRoutingRule* for the **Rule name**.

3. A routing rule requires a listener. On the **Listener** tab within the **Add a routing rule** window, enter the following values for the listener:

    - **Listener name**: Enter *myListener* for the name of the listener.
    - **Frontend IP**: Select **Public** to choose the public IP you created for the frontend.
  
      Accept the default values for the other settings on the **Listener** tab, then select the **Backend targets** tab to configure the rest of the routing rule.

       ![Screenshot](../Media/Module-2/a15140d0-01c1-4b57-afdf-58a1b32467b0.png)

4. On the **Backend targets** tab, select **appGatewayBackendPool** for the **Backend target**.

5. For the **HTTP setting**, select **Add new** to create a new HTTP setting. The HTTP setting will determine the behavior of the routing rule. In the **Add an HTTP setting** window that opens, enter *myHTTPSetting* for the **HTTP setting name**. Accept the default values for the other settings in the **Add an HTTP setting** window, then select **Add** to return to the **Add a routing rule** window. 



    ![Screenshot](../Media/Module-2/ca3f13f9-1610-45b7-ab4a-b666324c965f.png)

6. On the **Add a routing rule** window, select **Add** to save the routing rule and return to the **Configuration** tab.

      ![Screenshot](../Media/Module-2/08f1c080-a8fd-4fec-be0f-96bfe0535cbd.png)

7. Select **Add**

7. Select **Next: Tags** and then **Next: Review + create**, then select **Create**.


### Task 2: Test the application gateway

1.  Find the public IP address for the application gateway on the Overview screen. Click **All resources** and then click **myAGPublicIPAddress**.

     ![Screenshot](../Media/Module-2/f2549f46-1b7f-40bf-9aed-235265eaa9d8.png)
 
2.  Copy the public IP address, and then paste it into the address bar of your browser.

     ![Screenshot](../Media/Module-2/ea959c21-0774-413a-81aa-824547088c3d.png)

1.  To verify, go to **Network Watcher**, choose **Topology** then choose **myResourceGroupLB** to see the overall network diagram.

| WARNING: Prior to continuing you should remove all resources used for this lab.  To do this in the **Azure Portal** click **Resource groups**.  Select any resources groups you have created.  On the resource group blade click **Delete Resource group**, enter the Resource Group Name and click **Delete**.  Repeat the process for any additional Resource Groups you may have created. **Failure to do this may cause issues with other labs.** |
| --- |
**Results**: You have now completed this lab.
