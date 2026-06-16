#!/bin/bash

# 
# Created at: 06/07/2026
# Purpose: Check the Nodes and Pods that are consuming GPU
# License: GPL3
# Developer: Waldirio M Pinheiro <waldirio@gmail.com | waldirio@redhat.com>
# 

# jq binary is required
command=$(which jq)
if [ $? -ne 0 ]; then
  echo "jq not installed. Exiting ..."
  exit
fi

full_run()
{
    # Setting some variables
    TEMP_FILE="/tmp/temporary_file_gpu_check"
    fmt="%-40s %-80s %-15s %-10s\n"

    # Getting the list of Nodes that have the Nvidia GPU
    oc get nodes -o json | jq -r '.items[] | select(.status.capacity["nvidia.com/gpu"] != null).metadata.name' | while read node
    do 
        # Presenting the Node CPU Capacity
        echo "=== Node: $node ==="
        capacity=$(oc get node $node -o json | jq -r '.status.capacity["nvidia.com/gpu"]')
        echo "Total GPUs: $capacity"
    
        echo "Pods using GPUs:"
   
        # Generating the complete list of Pods that has the Nvidia resource limit and saving it as a temporary file
        all_pods_from_node=$(oc get pods -A --field-selector spec.nodeName=$node -o json | \
        jq -r '.items[] | select(.spec.containers[].resources.limits["nvidia.com/gpu"] != null)' > $TEMP_FILE)
   
        # Printing an empty line + the header
        echo
        printf "$fmt" NS POD GPU_Requests GPU_Limits

        # For loop to collect the information from the temporary file
        for pod_name in $(cat $TEMP_FILE | jq -r '.metadata.name' )
        do
            namespace=$(cat $TEMP_FILE | jq -r --arg pod_name $pod_name 'select(.metadata.name == $pod_name).metadata.namespace')

            pod_name=$(cat $TEMP_FILE | jq -r --arg pod_name $pod_name 'select(.metadata.name == $pod_name).metadata.name')

            gpu_requests=$(cat $TEMP_FILE | jq -r --arg pod_name $pod_name \
            'select(.metadata.name == $pod_name).spec.containers[].resources.requests["nvidia.com/gpu"]' | grep -v null)

            gpu_limits=$(cat $TEMP_FILE | jq -r --arg pod_name $pod_name \
            'select(.metadata.name == $pod_name).spec.containers[].resources.limits["nvidia.com/gpu"]' | grep -v null)

            # Printing it in a nice format
            printf "$fmt" $namespace $pod_name $gpu_requests $gpu_limits
        done
    done
}


# Main Checks
if [ "$1" == "--help" ]; then
  echo "'$0' - Execute a single run"
  echo "or"
  echo "'$0 -w' - Update every second"
  exit
elif [ "$1" == "-w" ]; then
  export -f full_run
  watch -x bash -c full_run
elif [ "$1" == "" ]; then
  full_run
else
  echo "Invalid Option. Exiting ..."
  exit
fi
