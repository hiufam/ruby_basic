MIN_VALUE = 0
MAX_VALUE = 7

class Vertex
  attr_accessor :coord, :predecessors

  def initialize(coord_arr, predecessors = [])
    @coord = coord_arr
    @predecessors = predecessors
  end

  def to_s
    @coord.to_s
  end
end

def knights_possible_next_moves(vertex)
  coord = vertex.coord

  possbile_coords = []
  possbile_coords << [coord[0] - 2, coord[1] + 1]
  possbile_coords << [coord[0] - 1, coord[1] + 2]
  possbile_coords << [coord[0] + 2, coord[1] + 1]
  possbile_coords << [coord[0] + 1, coord[1] + 2]
  possbile_coords << [coord[0] - 2, coord[1] - 1]
  possbile_coords << [coord[0] - 1, coord[1] - 2]
  possbile_coords << [coord[0] + 2, coord[1] - 1]
  possbile_coords << [coord[0] + 1, coord[1] - 2]

  filtered_coords = possbile_coords.select do |coord|
    coord[0] >= MIN_VALUE && coord[0] <= MAX_VALUE && coord[1] >= MIN_VALUE && coord[1] <= MAX_VALUE
  end

  filtered_coords.map { |coord| Vertex.new(coord, [vertex].concat(vertex.predecessors)) }
end

def is_vertex_visited(visited_list, vertex)
  visited_list.each do |visited_vertex|
    return true if visited_vertex.coord[0] == vertex.coord[0] && visited_vertex.coord[1] == vertex.coord[1]
  end

  false
end

def knight_moves(start_coord, end_coord)
  visited_vertices = []
  vertices_queue = [Vertex.new(start_coord)] # DFS queue

  while vertices_queue.length.positive?
    # ----
    next_vertex = vertices_queue.shift

    if next_vertex.coord == end_coord
      moves = [end_coord]
      next_vertex.predecessors.each do |preds|
        moves << preds.coord
      end

      return moves
    end
    next if is_vertex_visited(visited_vertices, next_vertex)

    visited_vertices << next_vertex

    vertices_queue.concat(knights_possible_next_moves(next_vertex))
    # ----
  end

  nil
end

p knight_moves([0, 0], [3, 3])
p knight_moves([3, 3], [0, 0])
p knight_moves([0, 0], [7, 7])
p knight_moves([3, 3], [4, 3])
