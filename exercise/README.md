# springboot -> docker -> k8s -> helm

## requirements
- a k8s cluster. GKE is easy as the setup process will install kubectl etc, but minikube will work too
	> https://cloud.google.com/kubernetes-engine/docs/quickstart (use local option)

- docker installed
	> https://docs.docker.com/install/

- a dockerhub account and docker logged in
	> `docker login`

- kubectl and helm installed and configured, and shell autocompletion
	> https://docs.helm.sh/using_helm/#quickstart-guide	
	> https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion

- maven installed + java8 and jq (https://stedolan.github.io/jq/)

- if you want to enable ingress, replace mysb.k8s.com.au in mysb/values.yaml with your domain, and configure + install:
	> https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress
	> https://github.com/kubernetes/charts/tree/master/stable/kube-lego

## setup
```
git clone git@github.com:wyvern8/spring-boot-rest-example.git
cd spring-boot-rest-example
```

## local build and run
```
mvn clean package
java -jar -Dspring.profiles.active=test target/spring-boot-rest-example-0.5.0.war
curl localhost:8091/health | jq 
```

## Dockerfile
create a Dockerfile in app root containing:
```
FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY target/spring-boot-rest-example-0.5.0.war /app
EXPOSE 8091
ENTRYPOINT ["java", "-Dspring.profiles.active=test","-jar","spring-boot-rest-example-0.5.0.war"]
```

## docker local build and run
```
docker build . -t [yourDockerHub]/mysb
docker run -p 8091:8091 [yourDockerHub]/mysb
curl localhost:8091/health | jq
```

## push to dockerhub and run in k8s directly
```
docker push zotoio/mysb:latest
kubectl run --image=[yourDockerHub]/mysb:latest mysb-service --port=8091
kubectl get pods
kubectl logs -f [podname]
```

## Optional: create a new chart and view templates/values 
```
cd charts/
helm create test-chart
cd test-chart && tree
```

## configure helm chart and install 
Update charts/mysb/values.yaml and replace [yourDockerHub] with your docker hub id/org.

> Optional.  if you want to try ingress with ssl, also update charts/mysb/values.yaml and change ingress enabled to true. and uncomment these annotations:
	#kubernetes.io/ingress.class: nginx
    #kubernetes.io/tls-acme: "true" 
```
helm install --name mysb-helm -f ./values.yaml
```

> Optional.  If you configured kubelego and nginx ingress.
```
curl https://mysb.k8s.com.au/health | jq
```

## some basic kubectl commands
```
kubectl get pods
kubectl describe pod [podname]
kubectl get deployments
kubectl get services
kubectl get ingress
```

## cleanup
```
kukectl delete mysb-service
helm delete --purge mysb-helm
```


