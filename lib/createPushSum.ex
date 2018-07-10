defmodule CreatePushSum do
    use Application
    require Logger
    def addNodesRand(w,s,ratio,count) do
        
        receive do
             {:ok, [map, cordinate,rw,rs]} -> [a,b,c,d] = [map, cordinate,rw,rs]
        end
        [map, cordinate,rw,rs] = [a,b,c,d]
        # spreadRand(map, cordinate, rw, rs, w, s)
        w = w + rw
        s = s + rs
        newratio = s/w

        #calculate difference
        diff = abs(newratio - ratio)
        #  IO.puts "#{inspect self()} #{inspect diff}"

        #test difference with threshold
        if diff < 1.0e-10 do
            count = count - 1
        else
            count = 3
        end

        # wucha = abs(newratio - 13) * 100 / 13

        if count == 0 do
            IO.puts "ratio is #{inspect newratio}  #{inspect self()}"
            # exit(wucha)
            Process.exit(self(), :kill)
        end
        

        #send to next
        # if Map.size(map) == 1 do
        #     exit("allDead error is #{wucha}%")
        # end
        nextcord = Enum.random(Map.keys(Map.delete(map,cordinate)))
        nextpid = Map.get(map,nextcord)

        # if Enum.random(1..5) == 1 do
        #     map = Map.delete(map,cordinate)
        # end
        send(nextpid, {:ok, [map, nextcord, w/2, s/2]})

        #repeat listen
        addNodesRand(w/2,s/2,newratio,count)
    end

    def addNodes2D(w,s,ratio,count) do
        
        receive do
             {:ok, [map, cordinate,rw,rs]} -> [a,b,c,d] = [map, cordinate,rw,rs]
        end
        [map, cordinate,rw,rs] = [a,b,c,d]
        # spreadRand(map, cordinate, rw, rs, w, s)
        w = w + rw
        s = s + rs
        newratio = s/w
        diff = abs(newratio - ratio)
        #  IO.puts "#{inspect self()} #{inspect diff}"
        if diff < 1.0e-10 do
            count = count - 1
        else
            count = 3
        end

        # wucha = abs(newratio - 13) * 100 / 13

        if count == 0 do
            IO.puts "ratio is #{inspect newratio} exit from #{inspect self()}"
            Process.exit(self(), :kill)
        end
        #send to next
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

        # if list ==[] do
            
        #     exit("allDead error is #{wucha}%")
        # end

        ne = Enum.random(list)
        nextpid = Map.get(map,ne)
        # if Enum.random(1..5) == 1 do
        #     map = Map.delete(map,cordinate)
        # end  
        send(nextpid, {:ok, [map, ne, w/2, s/2]})
        #repeat listen

         addNodes2D(w/2,s/2,newratio,count)
    end

    def addNodesLine(w,s,ratio,count) do
        
        receive do
             {:ok, [map, cordinate,rw,rs]} -> [a,b,c,d] = [map, cordinate,rw,rs]
        end
        [map, cordinate,rw,rs] = [a,b,c,d]
        # spreadRand(map, cordinate, rw, rs, w, s)
        w = w + rw
        s = s + rs
        newratio = s/w

        #calculate difference
        diff = abs(newratio - ratio)
        #  IO.puts "#{inspect self()} #{inspect diff}"

        #test difference with threshold
        if diff < 1.0e-10 do
            count = count - 1
        else
            count = 3
        end

        # wucha = abs(newratio - 13) * 100 / 13

        if count == 0 do
            IO.puts "ratio is #{inspect newratio} exit from #{inspect self()}"
            Process.exit(self(), :kill)
        end

        #send to next
        list = []
        if Map.has_key?(map, cordinate - 1) do
            list = [cordinate - 1 | list]
        end
        if Map.has_key?(map, cordinate + 1) do
            list = [cordinate + 1 | list]
        end
        # if list ==[] do
            
        #     exit("allDead error is #{wucha}%")
        # end
        
        nextcord = Enum.random(list)
        nextpid = Map.get(map,nextcord)
        # if Enum.random(1..5) == 1 do
        #     map = Map.delete(map,cordinate)
        # end 
        send(nextpid, {:ok, [map, nextcord, w/2, s/2]})

        #repeat listen
        addNodesLine(w/2,s/2,newratio,count)
    end

    def addNodesIm2D(w,s,ratio,count) do
        
        receive do
             {:ok, [map, cordinate,rw,rs,randmap]} -> [a,b,c,d,e] = [map, cordinate,rw,rs,randmap]
        end
        [map, cordinate,rw,rs,randmap] = [a,b,c,d,e]
        # spreadRand(map, cordinate, rw, rs, w, s)
        w = w + rw
        s = s + rs
        newratio = s/w
        diff = abs(newratio - ratio)
        #  IO.puts "#{inspect self()} #{inspect diff}"
        if diff < 1.0e-10 do
            count = count - 1
        else
            count = 3
        end
        # wucha = abs(newratio - 13) * 100 / 13

        # if count == 0 do
        #     IO.puts "ratio is #{inspect newratio} exit from #{inspect self()}"
        #     Process.exit(self(), wucha)
        # end
        #send to next
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

        #  if list ==[] do
            
        #     exit("allDead error is #{wucha}")
        # end

        ne = Enum.random(list)
        nextpid = Map.get(map,ne)
        # if Enum.random(1..100) == 1 do
        #     map = Map.delete(map,cordinate)
        #     randmap = Map.delete(randmap,cordinate)
        # end
        send(nextpid, {:ok, [map, ne, w/2, s/2,randmap]})
        #repeat listen

         addNodesIm2D(w/2,s/2,newratio,count)
    end

end