# frozen_string_literal: true

require_relative 'generate_board'
require_relative 'render_board'
require_relative 'position'

class DijkstraFinderThing
  def initialize
    @board = GenerateBoard.new(4, false, 'grass')
    puts RenderBoard.render(@board.rowified)
    @INFINITY = 50
    @field_index = []
    @routing = {}
    @starting_node = @board.field_at([3, 3])
    @target_node = @board.field_at([0, 0])
    add_edges
    dijkstra(@starting_node)
    print_path(@target_node)
    @shortest_path = []
    puts @shortest_path
  end

  def add_edges
    @board.array_of_fields.each do |field|
      @board.array_of_fields.each do |another_field|
        if field.position.distance(another_field.position) < 1.42
          add_edge(field, another_field, field.position.distance(another_field.position)) if field != another_field && field.obstacle == false && another_field.obstacle == false
        end
      end
    end
  end

  def add_edge(source, target, weight)
      if !@routing.key?(source)
        @routing[source] = { target => weight }
      else
        @routing[source][target] = weight
      end
      if !@routing.key?(target)
        @routing[target] = { source => weight }
      else
        @routing[target][source] = weight
      end
      @field_index << source unless @field_index.include?(source)
      @field_index << target unless @field_index.include?(target)
  end

  def store(destination)
    @shortest_path << destination
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

  def print_path(destination)
    if !@routing.key?(@target_node)
      return puts "NO PATH"
    end

    print_path @prev[destination] if @prev[destination] != -1
    print ">#{destination.position.to_a}"
  end
end

DijkstraFinderThing.new
