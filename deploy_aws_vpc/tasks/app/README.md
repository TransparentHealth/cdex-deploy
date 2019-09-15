# Process for App Server Deployment
 
    - /tasks/app/README.md

Repeat process for each app server flavor:

1. Create an EC2 instance
2. Deploy base toolset (Docker, Git etc.)
3. Clone code for app server (vmi, smh, smh_app)
4. Set environment variables for app/environment
5. Create AMI from Instance
6. Build Auto Scaling Group using AMI
7. Add AutoScaling Group into Target Group
8. Add Target Group to Application Load Balancer
9. Remove old target group
10. Terminate instances from old target group
11. Notify Slack/Teams

