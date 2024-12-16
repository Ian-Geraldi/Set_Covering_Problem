#!/bin/bash

# List of instance files
configs=("config2" "config4" "config5" "config6")
instances=("scp41" "scp42" "scp51" "scp52" "scp61" "scp62" "scpa1" "scpa2" "scpb1" "scpb2" "scpc1" "scpc2" "scpd1" "scpd2")
times=("60" "180")
seeds=("298329" "394149" "492929" "593929" "693929")

# Do jeito que foi pedido levaria 112 horas (14*6*5*(1+5+10)/60). Deixei com 1 e 3 minutos para rodar em 28 (14*6*5*(1+3)/60).

# Loop through each instance, time, config and seed
for config in "${configs[@]}"; do
    for instance in "${instances[@]}"; do
        for time in "${times[@]}"; do
            for seed in "${seeds[@]}"; do
                # Run the Julia script with the current instance, time, and seed
                echo "Running for instance ${instance}, time ${time}, and seed ${seed}..."
                julia mainComplete.jl -c "configs/${config}.config" -s ${seed} -r T -a 0 -t ${time} -i "data/${instance}.txt" >> "Results/log_${instance}_${time}seconds_${config}.txt" 2>&1
                
                # Check if the Julia script ran successfully
                if [ $? -ne 0 ]; then
                    echo "Error running Julia script with ${instance}, time ${time}, and seed ${seed}. Exiting."
                    exit 1
                fi
            done
        done
    done
done

echo "All commands executed successfully."