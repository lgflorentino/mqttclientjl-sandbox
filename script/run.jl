import Pkg

cd("../mqttclient.jl")

Pkg.activate(".")
Pkg.test()


print("Exiting run.jl\n")
