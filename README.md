# wordpress-mysql-deployment
Let me Introduce to project. 
The project is based on web-application in which wordpress is used as frontend and mysql is used as a database.
Basically WordPress is a free and open-source content management system written in PHP and paired with a MySQL database.

But, do you know behind the scene how they are hosted on server.
Here comes use of DevOps technologies like Docker, Kubernetes, and many more.
Technologies used in this projects are Docker and Kubernetes.


How to use this project.
Step1: Clone it 
   
    git clone https://github.com/viveksahu26/wordpress-mysql-deployment.git

Step2: Start your Kubernetes Cluster.
Step3: Install Helm in minikube: 


       >> curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 > get_helm.sh
       >> chmod 700 get_helm.sh
       >> ./get_helm.sh
       
   Install helm other than minikube.:-
      
      https://dev.to/viveksahu26/how-to-install-helm-version-above-3-in-linux-3bf1
      
Step4: Create a Directory inside minikube.  
       Go to virtualBox --> Click on minikube --> show --> minikube login: docker  and Password: tcuser
       Now You have landed on your terminal
       Run these commands
       
       $ sudo su
       $mkdir /wpdata          // This will contain wordpress pages.
   
   
       $mkdir /mysqldata   // This will contain data of wordpress page.
       
   Now, minimize VM/minikube.

Step5: Now get back to you localhost terminal.
       Go inside the folder where you clone this repo and open terminal here.

Step6: 
     
     >> helm install chart/       // It will run your deployment automatically.

Step7: To check it's running or not.

       >> minikube ip         // Remember the Ip
       >> Kubectl get svc     //On column Port, Note down 5-digit no. and its your wordpress_port
          
   Go to browser and search--> 
   
     http://<minikube_ip>:<wordpress_port>
       
Step8: Choose language and Enter.
Step9: 

    Database Name: wpdb
    Username: vivek
    Password: redhat
    Database Host: <minikube_ip>
    
Step10: Now create your blog.

I think, it may be useful to you.
Any problem just comment.

       
