push!(LOAD_PATH, ".")
# function julia {C:\Users\pessoa\AppData\Local\Julia-1.0.5\bin\julia.exe $args}
# julia main.jl data\scp41.txt 0
# & 'C:\Users\Luciana Pessoa\AppData\Local\Programs\Julia\Julia-1.4.0\bin\julia.exe' main.jl data\scp41.txt 0

########################################
# Leitura dos argumentos e da instancia
########################################


include("scpInstance.jl") #scpInstance contém a estrutura de dados da instância
include("construtivos.jl")

if length(ARGS) < 3
    println("Usage: julia main.jl <scp-instance-file> <cod-metodo> <seed>") #print mensagem de erro caso o numero de parametros nao esteja correto
    exit(1)
end

instance_file = ARGS[1] # instance_file recebe o nome do arquivo da instancia
cod_metodo = parse(Int64, ARGS[2])
seed = parse(Int64, ARGS[3])

instance = scpInstance(instance_file) #instancia recebe os dados lidos pelo construtor scpInstance

########################################
# Chamada do metodo construtivo
########################################


startt = time() #inicia o contador de tempo

if(cod_metodo==0)
   S, cost, v_cobertura = constByCost(instance) # chama o metodo construtivo "constByCost"
elseif(cod_metodo == 1)
   S, cost, v_cobertura = outroConst(instance) # chama o outro metodo contrutivo
else 
   using Random 
   Random.seed!(seed)  # define a seed aleatoria
   chrms = rand(instance.num_col)   # cria o vetor de chaves aleatorias
   S, cost, v_cobertura = randomConst(instance, chrms) # chama o construtivo aleatorio
end


totaltime =  time() - startt  #encerra o contador de tempo
tround = round(totaltime,digits=2)

println("Tempo:  $tround") #imprime o tempo
println("Custo $cost") #imprime o custo e a solucao
println("Solucao $S)") #imprime o custo e a solucao