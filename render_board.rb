# frozen_string_literal: true

class RenderBoard
  # 'tree': '🌲',
  @@RENDER_KEY = {
    'dirt': '🟫',
    'grass': '🟩'
  }

  def self.render(rowified_board)
    rendered_board = String.new(encoding: 'UTF-8')
    rowified_board.each_with_index do |row, index|
      row.each do |field|
        rendered_board << if field.is_occupied?
                            field.occupant.type.chr + field.occupant.owner
                          else
                            @@RENDER_KEY[field.terrain.to_sym]
                          end
      end
      rendered_board << "\n" if index < rowified_board.size - 1
    end
    rendered_board
  end
end
