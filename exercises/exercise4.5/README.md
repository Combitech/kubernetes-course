<!-- markdownlint-disable MD013 -->
# Exercise 4.5 Helm

> ❗ **NOTE:** No need to add or modify any templates

We have packaged a helm chart for you!

Can be accessed via a public repository
oci://combikubepublic.azurecr.io/charts/combikubecourse
1. Remove your previous deployments/pods for Producer & Consumer
2. Override parameters to get the same result as in Exercise 4
   
Tip! `helm show values oci://combikubepublic.azurecr.io/charts/combikubecourse`

3. Install the producer and consumer via the chart
   
Tip! `helm -n <namespace> install <name> oci://combikubepublic.azurecr.io/charts/combikubecourse -f <values-file>`
