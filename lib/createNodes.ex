defmodule CreateNodes do
    use Application
    require Logger


    def addNodesRand(count) do
        
        receive do
             {:ok, [map, cordinate]} -> spreadRand(map, cordinate, count = count + 1)
        end
        addNodesRand(count)
    end

    def spreadRand(map, cordinate, count) do
        #   IO.puts "#{inspect self()}"
        # IO.puts "#{inspect self()}" <> " " <> "#{inspect cordinate}" <> " " <> "#{inspect count}"
        if count == 10 do
             
             Process.exit(self(), :kill)
        end


        nextcord = Enum.random(Map.keys(Map.delete(map,cordinate)))
        nextpid = Map.get(map,nextcord)
        send(nextpid, {:ok, [map, nextcord]})
        
        # spreadRand(map,cordinate,count)

    end

    def addNodes2D(count) do
        receive do
             {:ok, [map, cordinate]} -> spread2D(map, cordinate, count = count + 1)
        end
        # IO.puts "#{inspect self()}" <> " " <> "#{inspect count}"
        

        addNodes2D(count)
    end

    def spread2D(map, cordinate, count) do
        # IO.puts "#{inspect self()}" <> " " <> "#{inspect cordinate}" <> " " <> "#{inspect count}"
        
         if count == 10 do
             Process.exit(self(), :kill)
         end
         row = round(:math.sqrt(Enum.count(map)))
        #  IO.puts(row)
         x = elem(cordinate,0)
         y = elem(cordinate,1)
         list = []
         if Map.has_key?(map,{x + 1, y}) do
             list = [{x + 1, y} | list]
         end
         if Map.has_key?(map,{x - 1, y}) do
             list = [{x - 1, y} | list]
         end
         if Map.has_key?(map,{x, y + 1}) do
             list = [{x, y + 1} | list]
         end
         if Map.has_key?(map,{x, y - 1}) do
             list = [{x , y - 1} | list]
         end

        #  list = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
       
        #  ne = Enum.random(Enum.reduce(list,map, fn(x,acc)-> if Map.has_key?(acc,x), do: li = [x | li] end))
         ne = Enum.random(list)
        nextpid = Map.get(map,ne)  
        send(nextpid, {:ok, [map, ne]})
        # spread2D(map, cordinate, count)
    end

    def addNodesLine(count) do

        receive do
             {:ok, [map, cordinate]} -> spreadLine(map, cordinate, count = count + 1)
        end
        # IO.puts "#{inspect self()}" <> " " <> "#{inspect count}"
        addNodesLine(count)
    end

    def spreadLine(map, cordinate, count) do
        #    IO.puts "#{inspect self()}" <> " " <> "#{inspect cordinate}" <> " " <> "#{inspect count}"
        
         if count == 10 do
             Process.exit(self(), :kill)
         end

        # nextcord = Enum.random(Map.keys(Map.delete(map,cordinate)))
        list = []
        if Map.has_key?(map, cordinate - 1) do
            list = [cordinate - 1 | list]
        end
        if Map.has_key?(map, cordinate + 1) do
            list = [cordinate + 1 | list]
        end
        
        nextcord = Enum.random(list)
        nextpid = Map.get(map,nextcord)
        # IO.puts "#{inspect nextcord}"<> " #{inspect nextpid}"
        send(nextpid, {:ok, [map, nextcord]})
        
        # spreadLine(map,cordinate,count)

    end

    def addNodesIm2D(count) do

        receive do
             {:ok, [map, cordinate, randmap]} -> spreadIm2D(map, cordinate, randmap, count = count + 1)
        end
        addNodesIm2D(count)
    end

    def spreadIm2D(map, cordinate, randmap, count) do
        # IO.puts "#{inspect self()}" <> " " <> "#{inspect cordinate}" <> " " <> "#{inspect count}"
        
         if count == 10 do
             Process.exit(self(), :kill)
         end
        #  row = round(:math.sqrt(Enum.count(map)))
        #  IO.puts(row)
         x = elem(cordinate,0)
         y = elem(cordinate,1)
         list = [Map.get(randmap,cordinate)]
         if Map.has_key?(map,{x + 1, y}) do
             list = [{x + 1, y} | list]
         end
         if Map.has_key?(map,{x - 1, y}) do
             list = [{x - 1, y} | list]
         end
         if Map.has_key?(map,{x, y + 1}) do
             list = [{x, y + 1} | list]
         end
         if Map.has_key?(map,{x, y - 1}) do
             list = [{x , y - 1} | list]
         end


        #   IO.puts "#{inspect list}"

        #  list = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
       
        #  ne = Enum.random(Enum.reduce(list,map, fn(x,acc)-> if Map.has_key?(acc,x), do: li = [x | li] end))
         ne = Enum.random(list)
        nextpid = Map.get(map,ne)  
        send(nextpid, {:ok, [map, ne, randmap]})
        # spreadIm2D(map, cordinate, randcord, count)
    end

end