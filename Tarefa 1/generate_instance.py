import random

def generate_matrix(clients, satellites, reachability_odds=0.15):
    matrix = [[0 for _ in range(satellites)] for _ in range(clients)]

    # Garantir que não há linhas com 0s apenas
    for i in range(clients):
        satellite = random.randint(0, satellites - 1)
        matrix[i][satellite] = 1

    # Garantir que não há colunas com 0s apenas
    for j in range(satellites):
        client = random.randint(0, clients - 1)
        matrix[client][j] = 1

    # Preencher o restante da matriz com 0s e 1s com 15% de chance de ser 1.
    for i in range(clients):
        for j in range(satellites):
            # Só preencher se for 0 pq se for 1 é um dos que preenchemos por garantia.
            if matrix[i][j] == 0:
                matrix[i][j] = 1 if random.random() < reachability_odds else 0

    return matrix

def generate_output(matrix):
    output = []
    for row in matrix:
        satellites = [j + 1 for j, value in enumerate(row) if value == 1]
        line = f"{len(satellites)} " + " ".join(map(str, satellites))
        output.append(line)
    return output

def write_output_to_file(output, clients, satellites, filename):
    with open(filename, "w") as file:
        # Primeira linha
        file.write(f"{clients} {satellites}\n")
        
        # Custo aleatório para a segunda linha
        costs = [str(random.randint(1, 5)) for _ in range(satellites)]
        file.write(" ".join(costs) + "\n")
        
        # Resto
        for line in output:
            file.write(line + "\n")

clients = 10
satellites = 20

random_matrix = generate_matrix(clients, satellites)

output_lines = generate_output(random_matrix)

write_output_to_file(output_lines, clients, satellites, "IGC.txt")

print(f"\nMatriz Gerada:")
for row in random_matrix:
    print(row)
