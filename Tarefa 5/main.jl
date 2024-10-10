using BrkgaMpIpr

include("scpInstance.jl")
include("scpDecoder.jl")

if length(ARGS) < 4
   println("Usage: julia main_minimal.jl <seed> <config-file> " *
           "<num-generations> <instance-file>")
   exit(1)
end

seed = parse(Int64, ARGS[1])
configuration_file = ARGS[2]
num_generations = parse(Int64, ARGS[3])
instance_file = ARGS[4]


instance = scpInstance(instance_file)

brkga_data, control_params = build_brkga(
    instance, scp_decode!, MINIMIZE, seed, instance.num_col,
    configuration_file
)



initialize!(brkga_data)
evolve!(brkga_data, num_generations)
best_cost = get_best_fitness(brkga_data)
@show best_cost
