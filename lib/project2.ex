defmodule MyApp.CLI do
  require Logger
  	def main(args) do
    	Logger.info "Gossip Protocol Start"
      Process.flag(:trap_exit, true)
      
    
      args |> selectTopology# |> hangon


  	end

    def selectTopology(args) do
      [numNodes, topology, algorithm] = args
      numNodes = String.to_integer(numNodes)
      case topology do
        "full" -> createFullNetwork(numNodes, topology, algorithm)
        "2D" -> create2dGrid(numNodes,topology,algorithm)
        "line" -> createLine(numNodes,topology,algorithm)
        "imp2D" -> createIm2dGrid(numNodes,topology,algorithm)
      end
    end

    def createFullNetwork(numNodes,topology,algorithm) do
      # IO.puts(numNodes)
      # IO.puts(topology)
      case algorithm do
        "gossip" -> map = Enum.reduce(1..numNodes, %{}, fn(x, acc) -> Map.put(acc, x, spawn_link(CreateNodes, :addNodesRand, [0])) end)
        "Push-Sum" -> map = Enum.reduce(1..numNodes, %{}, fn(x, acc) -> Map.put(acc, x, spawn_link(CreatePushSum, :addNodesRand, [1,x,x/1,3])) end)
      end
      
      initcord = Enum.random(Map.keys(map))
       Logger.info "#{inspect initcord}"
      start_time = :erlang.system_time
      case algorithm do
        "gossip" -> send Map.get(map,initcord),{:ok, [map, initcord]}
        "Push-Sum" -> send Map.get(map,initcord),{:ok, [map, initcord, 0,0]}
      end

      receive do
        msg-> IO.puts "Message Received: #{inspect msg}, time cost #{:erlang.system_time - start_time} microsecond"
      end
      
    end

    def create2dGrid(numNodes,topology,algorithm) do
      # IO.puts(numNodes)
      # IO.puts(topology)
      numNodes = round(:math.sqrt(numNodes))
      row = numNodes
      numNodes = numNodes * numNodes
      # IO.puts "#{inspect numNodes}"

      case algorithm do
       "gossip" -> map = Enum.reduce(0..(numNodes - 1), %{}, fn(x, acc) -> Map.put(acc, {div(x,row),rem(x,row)}, spawn_link(CreateNodes, :addNodes2D, [0])) end)
       "Push-Sum" -> map = Enum.reduce(0..(numNodes - 1), %{}, fn(x, acc) -> Map.put(acc, {div(x,row),rem(x,row)}, spawn_link(CreatePushSum, :addNodes2D, [1,x+1,(x+1)/1,3])) end)
      end

       initcord = Enum.random(Map.keys(map))
       # Logger.info "#{inspect initcord}"
       start_time = :erlang.system_time
       case algorithm do
        "gossip" -> send Map.get(map,initcord),{:ok, [map, initcord]}
        "Push-Sum" -> send Map.get(map,initcord),{:ok, [map, initcord, 0,0]}
       end
       receive do
        msg-> IO.puts "Message Received: #{inspect msg}, time cost #{:erlang.system_time - start_time} microsecond"
      end
      
    end

    def createLine(numNodes,topology,algorithm) do
      case algorithm do
        "gossip" -> map = Enum.reduce(1..numNodes, %{}, fn(x, acc) -> Map.put(acc, x, spawn_link(CreateNodes, :addNodesLine, [0])) end)
        "Push-Sum" -> map = Enum.reduce(1..numNodes, %{}, fn(x, acc) -> Map.put(acc, x, spawn_link(CreatePushSum, :addNodesLine, [1,x,x/1,3])) end)
      end
      
      initcord = Enum.random(Map.keys(map))
      # Logger.info "#{inspect initcord}"
      start_time = :erlang.system_time

      case algorithm do
        "gossip" -> send Map.get(map,initcord),{:ok, [map, initcord]}
        "Push-Sum" -> send Map.get(map,initcord),{:ok, [map, initcord, 0,0]}
      end
      receive do
        msg-> IO.puts "Message Received: #{inspect msg}, time cost #{:erlang.system_time - start_time} microsecond"
      end
    end

    def createIm2dGrid(numNodes,topology,algorithm) do
      # IO.puts(numNodes)
      # IO.puts(topology)
      numNodes = round(:math.sqrt(numNodes))
      row = numNodes
      numNodes = numNodes * numNodes

      case algorithm do
        "gossip" -> map = Enum.reduce(0..(numNodes - 1), %{}, fn(x, acc) -> Map.put(acc, {div(x,row),rem(x,row)}, spawn_link(CreateNodes, :addNodesIm2D, [0])) end)
        "Push-Sum" -> map = Enum.reduce(0..(numNodes - 1), %{}, fn(x, acc) -> Map.put(acc, {div(x,row),rem(x,row)}, spawn_link(CreatePushSum, :addNodesIm2D, [1,x+1,(x+1)/1,3])) end)
      end
      
       initcord = Enum.random(Map.keys(map))
       randmap  = Enum.reduce(Map.keys(map), %{}, fn(x,acc) -> Map.put(acc,x,Enum.random(Map.keys(Map.delete(map,x)))) end)
      
      IO.puts "#{inspect randmap}"
      start_time = :erlang.system_time

      #  send Map.get(map,initcord),{:ok, [map, initcord,randmap]}
       case algorithm do
        "gossip" -> send Map.get(map,initcord),{:ok, [map, initcord,randmap]}
        "Push-Sum" -> send Map.get(map,initcord),{:ok, [map, initcord, 0,0,randmap]}
      end
      
      receive do
        msg-> IO.puts "Message Received: #{inspect msg}, time cost #{:erlang.system_time - start_time} microsecond"
      end
      
    end

    
end
