push!(LOAD_PATH, ".")
using Dates
using Statistics
# function julia {C:\Users\pessoa\AppData\Local\Julia-1.0.5\bin\julia.exe $args}
# julia main.jl data\scp41.txt 0
# & 'C:\Users\Luciana Pessoa\AppData\Local\Programs\Julia\Julia-1.4.0\bin\julia.exe' main.jl data\scp41.txt 0

########################################
# Leitura dos argumentos e da instancia
########################################


include("scpInstance.jl") #scpInstance contém a estrutura de dados da instância
include("construtivos.jl")
instance_names = ["IGC1"]
iterations = 10
for instance_name in instance_names #para i de 1 ao tamanho do vetor instance_names
   costs = []
   times = []
   for i = 1:iterations
      instance_file = "Tarefa 3/data/$(instance_name).txt" # instance_file recebe o nome do arquivo da instancia
      cod_metodo = 2

      instance = scpInstance(instance_file) #instancia recebe os dados lidos pelo construtor scpInstance
      println("Instancia lida") #imprime a mensagem de que a instancia foi lida

      ########################################
      # Chamada do metodo construtivo
      ########################################


      startt = time() #inicia o contador de tempo

      if(cod_metodo==0)
         S, cost, v_cobertura = constByCost(instance) # chama o metodo construtivo "constByCost"
      elseif(cod_metodo == 1)
         S, cost, v_cobertura = outroConst(instance) # chama o outro metodo contrutivo
      else 
         seed = rand(UInt64) # generate a random seed
         using Random
         # write the seed in a txt file
         seed_file = "Seeds/$(instance_name) $(Dates.format(now(), "mm-dd_HH-MM-SS")).txt"
         open(seed_file, "w") do file
            write(file, string(seed))
         end

         Random.seed!(seed)  # define a seed aleatoria
         chrms = rand(instance.num_col)   # cria o vetor de chaves aleatorias
         S, cost, v_cobertura = randomConst(instance, chrms) # chama o construtivo aleatorio
      end

      totaltime =  time() - startt  #encerra o contador de tempo
      tround = round(totaltime,digits=2)

      println("Tempo:  $tround") #imprime o tempo
      push!(times, tround)
      println("Custo $cost") #imprime o custo e a solucao
      push!(costs, cost)
      println("Solucao $S)") #imprime o custo e a solucao
      #write the cost in a csv file
      cost_file = "Results/$(instance_name).csv"
      if !isfile(cost_file)
         open(cost_file, "w") do file
            write(file, "Cost\n")  # Adiciona um cabeçalho ao arquivo
         end
      end
      open(cost_file, "a") do file  # Modo de adição
            write(file, string(cost) * "," * string(tround) * "\n")  # Adiciona uma nova linha após o custo
      end
      if i == iterations
         open(cost_file, "a") do file
            write(
            file,
            "Média dos custos: " * string(mean(costs)) * "\n"
            * "Média dos tempos: " * string(mean(times)) * "\n"
            * "Menor custo: " * string(minimum(costs)) * "\n"
            )
         end
      end
   end
end
