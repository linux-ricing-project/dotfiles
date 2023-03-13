alias k="kubecolor"

function kube-get-my-namespaces(){
    kubectl get ns --no-headers=true | egrep -v "default|kube*|local-path-storage"
}