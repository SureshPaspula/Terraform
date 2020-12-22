EKS_CLUSTER_NAME=${eks_cluster_name}

aws eks --region ${aws_region} update-kubeconfig --name $EKS_CLUSTER_NAME

if ! kubectl config current-context | grep "$EKS_CLUSTER_NAME"; then
  echo "kubectl context doesn't match current deployment: $EKS_CLUSTER_NAME"
  kubectl config current-context
  exit
fi

pachctl deploy amazon ${bucket_name} ${aws_region} ${storage_size} \
  --iam-role=${iam_role} \
  --dynamic-etcd-nodes=1 \
  --etcd-cpu-request=100m \
  --pachd-cpu-request=200m

echo "Expose pachyderm gRPC internally using NLB"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: pachd-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-internal: "true"
    external-dns.alpha.kubernetes.io/hostname: ${pachd_url}
spec:
  type: LoadBalancer
  selector:
    app: pachd
    suite: pachyderm
  ports:
    - protocol: TCP
      port: 650
      targetPort: 650
EOF

kubectl get all
