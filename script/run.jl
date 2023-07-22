#!/bin/julia 

import Pkg
Pkg.activate(".")


cwd = pwd()
cd("../mqttclient.jl")

if ARGS[1] == "test" 
    
    using Test
    using MQTTClient
    using Distributed, Random

    import MQTTClient: topic_wildcard_len_check, filter_wildcard_len_check, MQTTException
    import Sockets: TCPSocket, PipeServer, connect
    
    # ./ctrlr.sh run test <testset-name>
    testset = ARGS[2]
    include("$(pwd())/test/unittest.$testset.jl")
elseif ARGS[1] == "tests"
    # ./ctrlr.sh run tests
    # runs all tests in the package
    cd(cwd)
    Pkg.test("MQTTClient")
end

print("Exiting run.jl\n")
