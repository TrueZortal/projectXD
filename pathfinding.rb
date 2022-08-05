# frozen_string_literal: true



class Pathfinding
  def initialize(starting_field_object, target_field_object, pathfinding_data_array)
    @INFINITY = 50
    @field_index = pathfinding_data_array[1]
    @routing = pathfinding_data_array[0]
    @starting_node = starting_field_object
    @target_node = target_field_object
    dijkstra(@starting_node)
  end


  def dijkstra(source)
    if !@routing.key?(@target_node)
      return
    end
    @distance = {}
    @prev = {}

    @field_index.each do |field|
      @distance[field] = @INFINITY
      @prev[field] = -1
    end

    @distance[source] = 0
    unvisited_nodes_queue = @field_index.compact
    while unvisited_nodes_queue.size.positive?
      current_node = nil
      unvisited_nodes_queue.each do |node|
        current_node = node if !current_node || (@distance[node] && @distance[node] < @distance[current_node])
      end
      break if @distance[current_node] == @INFINITY
      unvisited_nodes_queue -= [current_node]
      @routing[current_node].each_key do |another_node|
        alternative_route = @distance[current_node] + @routing[current_node][another_node]
        if alternative_route < @distance[another_node]
          @distance[another_node] = alternative_route
          @prev[another_node] = current_node
        end
      end
    end
  end

  def shortest_path_and_distance
    @shortest_path = []
    distance = 0
    if !@routing.key?(@target_node)
      return puts "NO PATH"
    end

    until @target_node == @starting_node do
      if @prev[@target_node] != -1
        @shortest_path << @target_node
      end
      distance += @routing[@prev[@target_node]][@target_node]
      @target_node = @prev[@target_node]
    end
    @shortest_path << @target_node

    {@shortest_path => distance}
  end
end


