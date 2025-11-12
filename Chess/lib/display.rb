module Display
  def display_board(pieces_map)
    alphabet = 'ABCDEFGH'
    numeric = '87654321'
    row_str = ''
    pieces_map.each_with_index do |row, index|
      row_str << numeric[index]
      row.each do |slot|
        row_str += if slot.nil?
                     '[ ]'
                   else
                     "[#{slot.icon}]"
                   end
      end
      row_str << "\n"
    end
    row_str << '  A  B  C  D  E  F  G  H'
    puts row_str
  end

  def display_turn(turn)
    puts "current turn: #{turn}"
  end

  def display_hint(promote_piece)
    puts "commands: quit - \"q\", reset move - \"rm\" #{promote_piece.nil? ? '' : ', promote - "p"'}"
  end

  def display_promote_pieces
    puts '1:queen, 2:rook, 3:bishop, 4:knight'
  end

  def display_choose_piece
    puts 'choose piece:'
  end

  def display_choose_move(piece)
    puts "choose move for #{piece.type}:"
  end

  def display_current_choice(piece, move)
    puts "current action: move #{piece.type} to #{move}, confirm: \"y\" "
  end

  def display_king_checked(piece)
    puts "#{piece.side} king is checked!"
  end

  def display_error(error)
    puts "error: #{error}"
  end

  def display_winner(winner)
    puts "#{winner} wins!"
  end
end
