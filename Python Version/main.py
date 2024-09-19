import time
import random
import datetime

# Include necessary files (you can import relevant functions/modules)
from scp_instance import scpInstance
from construtivos import constByCost, outroConst, randomConst

########################################
# Leitura dos argumentos e da instancia
########################################

# Check if the correct number of arguments are passed
# ARGS in Julia refers to command-line arguments. In Python, use sys.argv.

instance_file = "Tarefa 2/data/IGC1.txt"  # instance_file receives the name of the instance file
cod_metodo = 2  # Method code

instance = scpInstance(instance_file)  # Load instance data

########################################
# Chamada do metodo construtivo
########################################

start_time = time.time()  # Start time counter

if cod_metodo == 0:
    S, cost, v_cobertura = constByCost(instance)  # Call constByCost method
elif cod_metodo == 1:
    S, cost, v_cobertura = outroConst(instance)  # Call outroConst method
else:
    seed = random.getrandbits(64)  # Generate a random seed
    random.seed(seed)  # Set the random seed

    # Write the seed to a text file
    seed_file = "seed_{}.txt".format(datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
    with open(seed_file, "w") as file:
        file.write(str(seed))

    chrms = [random.random() for _ in range(instance.num_col)]  # Generate random keys vector
    S, cost, v_cobertura = randomConst(instance, chrms)  # Call random method

# Calculate total time
total_time = round(time.time() - start_time, 2)

# Print results
print(f"Tempo: {total_time}")
print(f"Custo: {cost}")
print(f"Solucao: {S}")
