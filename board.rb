# frozen_string_literal: true

require_relative 'field'
require_relative 'render_board'
require_relative 'generate_board'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

# working surface for board is @rowified_board, might want to possibly separate Creating the board from the board class
class Board
  attr_reader :upper_limit
  attr_accessor :rowified_board

  def initialize(size_of_board_edge, uniform: true, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @rowified_board = GenerateBoard.new(size_of_board_edge, uniform, starting_surface).rowified
    @size_of_board_edge = size_of_board_edge
    @upper_limit = @size_of_board_edge - 1

    starting_summoning_zones
  end

  def render_board
    RenderBoard.render(@rowified_board)
  end

  def state
    @rowified_board
  end

  def check_field(position_object)
    unless position_object.to_a.size == 2 && position_object.to_a.first <= @upper_limit && position_object.to_a.last <= @upper_limit
      raise InvalidPositionError
    end

    @rowified_board[position_object.x][position_object.y]
  end

  def valid_position(position)
    position.to_a.none? { |coordinate_value| coordinate_value > @upper_limit }
  end

  def grab_a_starting_summoning_zone
    @summoning_zones = @summoning_zones.shuffle
    zone = @summoning_zones.pop
    zone.map(&:to_a)
  end

  def starting_summoning_zones
    find_summoning_zone_coordinate_arrays
    @summoning_zones = set_summoning_zones_to_be_positions
    @summoning_zones
  end

  def zone_message(zone)
    zone_edge = Math.sqrt(@size_of_board_edge).to_i
    "Your summoning zone is #{identify_starting_zone(zone)} and has a size of #{zone_edge}x#{zone_edge} squares"
  end

  private

  def identify_starting_zone(zone)
    if zone.include?([0, 0])
      'top left'
    elsif zone.include?([@upper_limit, 0])
      'top right'
    elsif zone.include?([0, @upper_limit])
      'bottom left'
    elsif zone.include?([@upper_limit, @upper_limit])
      'bottom right'
    end
  end

  def set_summoning_zones_to_be_positions
    coordinate_array_of_summoning_zones = find_summoning_zone_coordinate_arrays
    coordinate_array_of_summoning_zones.each do |summoning_zone|
      summoning_zone.map! { |coordinates_array| @rowified_board[coordinates_array[0]][coordinates_array[1]].position }
    end
    coordinate_array_of_summoning_zones
  end

  def find_summoning_zone_coordinate_arrays
    array = *(0..upper_limit).to_a
    limit = Math.sqrt(array.size).to_i
    lower_bound = array[0..limit - 1]
    upper_bound = array[0 - limit..]
    array_of_summoning_zones = []
    array_of_summoning_zones << combine_bounds(upper_bound, lower_bound)
    array_of_summoning_zones << combine_bounds(lower_bound, lower_bound)
    array_of_summoning_zones << combine_bounds(lower_bound, upper_bound)
    array_of_summoning_zones << combine_bounds(upper_bound, upper_bound)
    array_of_summoning_zones
  end

  def combine_bounds(bound1, bound2)
    temp_array = []
    bound1.each do |x|
      bound2.each do |y|
        temp_array << [x, y]
      end
    end
    temp_array
  end

  def is_an_obstacle?(terrain)
    obstacles = [
      'tree'
    ]
    obstacles.include?(terrain)
  end
end
