helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress ingress-nginx/ingress-nginx --namespace nginx --create-namespace 
# helm uninstall ingress