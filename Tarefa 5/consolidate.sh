#!/bin/bash

# Output CSV file
output_file="log.csv"

# Create or overwrite the CSV file with headers
echo "Instance,Time,Config,Best_Cost_1,Best_Cost_2,Best_Cost_3,Best_Cost_4,Best_Cost_5" > "$output_file"

# Process each log file
for log_file in Results/log_*.txt; do
    # Extract instance, time, and config from filename
    instance=$(echo "$log_file" | grep -oP 'scp[a-z]?\d+')
    time=$(echo "$log_file" | grep -oP '\d+seconds')
    time=${time%seconds}
    config=$(echo "$log_file" | grep -oP 'config\d+')

    # Extract best costs
    best_costs=$(grep -oP '% Best cost: \K\d+' "$log_file" | tr '\n' ',')

    # Remove trailing comma and add newline
    best_costs=${best_costs%,}

    # Append to CSV
    echo "$instance,$time,BRKGA $config,$best_costs" >> "$output_file"
done

echo "Processing complete. Results saved to $output_file"