**Infrastructure Design using Terraform**

VPC and Subnet: A new VPC and subnet are created, with the EC2 instance and ELB placed inside the subnet.
Security Group: Allows inbound traffic on ports 80 (HTTP) and 443 (HTTPS) to the instance.
EC2 Instance: Runs a basic Apache web server with a "Hello World" page.
ACM Certificate: This optional section uses AWS Certificate Manager (ACM) to manage SSL certificates for HTTPS.
Elastic Load Balancer: The ELB forwards HTTP (port 80) traffic and HTTPS (port 443) traffic, with SSL redirection configured.


**Server Configuration with Ansible**

Installs Apache.
Deploys a basic index.html.
Configures a self-signed SSL certificate.
Configures Apache to listen on HTTPS and redirects HTTP requests to HTTPS.

**Automated Tests with Ansible**

Verify Apache is installed and running.
Check that the "Hello World" page is being served.

This configuration helps you deploy a scalable and secure static web app in AWS using best practices for security (HTTPS with SSL) and scalability (ELB).
