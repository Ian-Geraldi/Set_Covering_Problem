#!/bin/bash

# List of file suffixes
suffixes=("scp41" "scp42" "scp51" "scp52" "scp61" "scp62" "scpa1" "scpa2" "scpb1" "scpb2" "scpc1" "scpc2" "scpd1" "scpd2")

# Loop through each suffix in the list
for suffix in "${suffixes[@]}"; do
    # Run the Julia script with the current suffix
    julia mainComplete.jl -c config.config -s 394149 -r T -a 0 -t 60 -i "data/${suffix}.txt"
    
    # Check if the Julia script ran successfully
    if [ $? -ne 0 ]; then
        echo "Error running Julia script with ${suffix}. Exiting."
        exit 1
    fi
done

echo "All commands executed successfully."
