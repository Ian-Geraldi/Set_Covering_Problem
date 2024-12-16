push!(LOAD_PATH, ".")


#using JuMP, CPLEX
#model = Model(CPLEX.Optimizer)

using JuMP, Cbc
model = Model(Cbc.Optimizer)

# & 'C:\Users\Luciana Pessoa\AppData\Local\Programs\Julia\Julia-1.4.0\bin\julia.exe' modelo.jl data\scp41.txt

########################################
# Read arguments and Instance
########################################


include("scpInstance.jl") #scpInstance contém a estrutura de dados da instância

if length(ARGS) < 1
    println("Usage: julia modelo.jl <scp-instance-file>") #print mensagem de erro caso o numero de parametros nao esteja correto
    exit(1)
end

instance_file = ARGS[1] # instance_file recebe o nome do arquivo da instancia


#println("Reading data...")
instance = scpInstance(instance_file) #instancia recebe os dados lidos pelo construtor scpInstance

#println(sum(instance.v_cost))
#println(instance.v_demand)

 #### fim da leitura da instancia ####

c=instance.v_cost # c recebe o vetor de custos
#println(c)
a=instance.m_coverage # a recebe a matriz de cobertura
#println(a)
N=instance.num_col # N recebe o numero de colunas
M=instance.num_lin # M recebe o numero de linhas
#println(N)
#println(M)



########################################
# Implementacao do modelo
########################################



@variable(model,x[j=1:N],Bin) 

@objective(model, Min, sum(c[j]* x[j] for j in 1:N))

for i in 1:M
    @constraint(model, sum(a[i,j]*x[j] for j in 1:N) >=1) 
end 
   

#print(model)

optimize!(model)
status = termination_status(model)
println(status)

println("Objective value: ", JuMP.objective_value(model))
println("x = ", JuMP.value.(x))
