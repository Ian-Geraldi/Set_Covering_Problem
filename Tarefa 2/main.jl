push!(LOAD_PATH, ".")
########################################
# Leitura dos argumentos e da instancia
########################################
println("Hello, World!")

include("scpInstance.jl") #scpInstance contém a estrutura de dados da instância
include("construtivos.jl")

# import from the data folder
instance_file = "data/IGC1.txt" # instance_file recebe o nome do arquivo da instancia
cod_metodo = 1


instance = scpInstance(instance_file) #instancia recebe os dados lidos pelo construtor scpInstance

########################################
# Chamada do metodo construtivo
########################################


startt = time() #inicia o contador de tempo


if(cod_metodo==0)
   S, cost, v_cobertura = constByCost(instance) # chama o metodo construtivo "constByCost"
else
   outroConst(instance) # chama o outro metodo contrutivo
end


totaltime =  time() - startt  #encerra o contador de tempo
tround = round(totaltime,digits=2)

println("Tempo:  $tround") #imprime o tempo
println("Custo $cost") #imprime o custo e a solucao
println("Solucao $S)") #imprime o custo e a solucao