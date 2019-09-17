# Application Server Deployment flow 

Author: mark
Created: 2019-09-17.11:24

Repository: cdex-deploy


## Summary

There are three phases to Deployment:

1. Build an instance
2. Configure the instance for a specific application (vmi, smh, smh_app)
3. Deploy the instance

### 1. Build

The management controller in an environment (staging | prod) creates an ec2 instance.

### 2. Configure

The management controller uses the private dns name of the created instance
to configure the application server with all of the required components
and variable values that are required.

The successful result of this process is a fully functional server.

This server can be added to the target group of the respective Application
Load Balancer or the Deploy process can be run.

### 3. Deploy

The management controller uses the instance id of the created and configured
machine to create an AMI.

The AMI is used to create a Launch Configuration.
The Launch configuration is used to create a Target Group.
The Target Group is then attached to the Application Load Balancer.

The previously attached instances and Target Group can then be terminated.

## Testing Phase

During the testing phase only Steps 1 and 2 will be run and the 
resulting machine will be added to the target group in the ALB.

### Production and stable development Phase

The production environment will run all three phases to create an 
Automated Scaling Group to deploy instances to the ALB.
