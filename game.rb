require 'ruby2d'

# create a class for the game of 2048
class Game2048
  # create a 4*4 grid panel
  def all_two_dim_arys
    arys = []
    xs = [@num_x1, @num_x2, @num_x3, @num_x4]
    ys = [@num_y1, @num_y2, @num_y3, @num_y4]
    xs.each { |x| ys.each { |y| arys << [x, y] } }
    arys
  end

  # identify the grids with texts(numbers)
  def text_two_dim_arys
    @texts.map { |t| [t.x, t.y] }
  end

  # find empty grids to determine whether the user loses the game
  def unused_two_dim_arys
    all_two_dim_arys - text_two_dim_arys
  end

  # create the winning sign
  def you_win
    @you_win = Text.new('YOU WIN!!!', size: 50, style: 'bold', color: 'red', z: 100, x: 20, y: 150)
  end

  # create the losing sign
  def you_lose
    @you_lose = Text.new('YOU LOSE!!!', size: 50, style: 'bold', color: 'red', z: 100, x: 20, y: 150)
  end

  # when there is/are empty grid(s), generate a new '2'; otherwise, the user loses the game.
  def gen_random_text
    return you_lose if unused_two_dim_arys.empty?
    xy = unused_two_dim_arys.shuffle.first
    new_num = Text.new(2, size: 25, style: 'bold', color: @new_color, z: 10,
                       x: xy[0],
                       y: xy[1])
    new_num
  end

  # put a '2' into a randomly chosen grid
  def gen_random_text!
    @texts << gen_random_text
  end

  # design the initial page
  def initialize
    @new_color = 'gray'
    @merged_color = 'green'
    @texts = []
    @num_x1, @num_x2, @num_x3, @num_x4 = 20, 120, 220, 320
    @num_y1, @num_y2, @num_y3, @num_y4 = 10, 110, 210, 310
    Window.set(title: '2048 Game', width: 390, height: 390)
    # draw the 16 grids
    s11 = Square.new(x: 0, y: 0, size: 90)
    s12 = Square.new(x: 100, y: 0, size: 90)
    s13 = Square.new(x: 200, y: 0, size: 90)
    s14 = Square.new(x: 300, y: 0, size: 90)
    s21 = Square.new(x: 0, y: 100, size: 90)
    s22 = Square.new(x: 100, y: 100, size: 90)
    s23 = Square.new(x: 200, y: 100, size: 90)
    s24 = Square.new(x: 300, y: 100, size: 90)
    s31 = Square.new(x: 0, y: 200, size: 90)
    s32 = Square.new(x: 100, y: 200, size: 90)
    s33 = Square.new(x: 200, y: 200, size: 90)
    s34 = Square.new(x: 300, y: 200, size: 90)
    s41 = Square.new(x: 0, y: 300, size: 90)
    s42 = Square.new(x: 100, y: 300, size: 90)
    s43 = Square.new(x: 200, y: 300, size: 90)
    s44 = Square.new(x: 300, y: 300, size: 90)
  end

  # create the function for running the game
  def run
    # first, randomly generate two '2's
    gen_random_text!
    gen_random_text!
    Window.on :key_down do |event|
      case event.key
      # using the left, right, up and down buttons to play the game. Also add the q button to quit the game
      when 'left'
        # when the user has winned/lost the game, the button doesn't work. the game just returns the winning/losing sign.
        return if @you_win or @you_lose
        # move accordingly
        leftwardly_rearrange
        # add up numbers accordingly
        leftwardly_merge_adjacent_nums
        # define the winning condition
        you_win if @texts.find { |e| e.text == '2048' }
        # generate a new '2' simultaneously
        gen_random_text!
      # the functions of right, up and down buttons are written using the same logic
      when 'right'
        return if @you_win or @you_lose
        rightwardly_rearrange
        rightwardly_merge_adjacent_nums
        you_win if @texts.find { |e| e.text == '2048' }
        gen_random_text!
      when 'up'
        return if @you_win or @you_lose
        upwardly_rearrange
        upwardly_merge_adjacent_nums
        you_win if @texts.find { |e| e.text == '2048' }
        gen_random_text!
      when 'down'
        return if @you_win or @you_lose
        downwardly_rearrange
        downwardly_merge_adjacent_nums
        you_win if @texts.find { |e| e.text == '2048' }
        gen_random_text!
      # when q button is clicked, quit the game
      when 'q'
        Window.close
      end
    end
    Window.show
  end

  # get the text from the grids (4 horizontal lines and 4 vertical lines)
  def texts_y1
    @texts.select { |t| t.y == @num_y1 }
  end

  def texts_y2
    @texts.select { |t| t.y == @num_y2 }
  end

  def texts_y3
    @texts.select { |t| t.y == @num_y3 }
  end

  def texts_y4
    @texts.select { |t| t.y == @num_y4 }
  end

  def texts_x1
    @texts.select { |t| t.x == @num_x1 }
  end

  def texts_x2
    @texts.select { |t| t.x == @num_x2 }
  end

  def texts_x3
    @texts.select { |t| t.x == @num_x3 }
  end

  def texts_x4
    @texts.select { |t| t.x == @num_x4 }
  end

  # add up numbers when the left button is clicked
  def leftwardly_merge_adjacent_nums
    texts_x2.each do |x2|
      #x2 is the right cell and x1 is the left cell
      tbase1 = @texts.find { |t| t.y == x2.y and t.x == @num_x1 }
      # if the two numbers equal, sum them up
      if (not tbase1.nil?) and tbase1.text == x2.text
        tbase1.text = tbase1.text.to_i * 2
        # after the two cells merge, change the color of the new number
        tbase1.color = @merged_color
        # and remove the right cell
        x2.remove
        @texts.delete(x2)
      end
    end
    # the logic is same for the rest calculations, go through the process of x1+x2, x2+x3, x3+x4
    texts_x3.each do |x3|
      tbase2 = @texts.find { |t| t.y == x3.y and t.x == @num_x2 }
      if (not tbase2.nil?) and tbase2.text == x3.text
        tbase2.text = tbase2.text.to_i * 2
        tbase2.color = @merged_color
        x3.remove
        @texts.delete(x3)
      end
    end
    texts_x4.each do |x4|
      tbase3 = @texts.find { |t| t.y == x4.y and t.x == @num_x3 }
      if (not tbase3.nil?) and tbase3.text == x4.text
        tbase3.text = tbase3.text.to_i * 2
        tbase3.color = @merged_color
        x4.remove
        @texts.delete(x4)
      end
    end
  end

  # add up numbers when the up button is clicked, same logic as above. But this time adding up y-cells. going through y1+y2, y2+y3 and y3+y4
  def upwardly_merge_adjacent_nums
    texts_y2.each do |y2|
      tbase1 = @texts.find { |t| t.x == y2.x and t.y == @num_y1 }
      if (not tbase1.nil?) and tbase1.text == y2.text
        tbase1.text = tbase1.text.to_i * 2
        tbase1.color = @merged_color
        y2.remove
        @texts.delete(y2)
      end
    end
    texts_y3.each do |y3|
      tbase2 = @texts.find { |t| t.x == y3.x and t.y == @num_y2 }
      if (not tbase2.nil?) and tbase2.text == y3.text
        tbase2.text = tbase2.text.to_i * 2
        tbase2.color = @merged_color
        y3.remove
        @texts.delete(y3)
      end
    end
    texts_y4.each do |y4|
      tbase3 = @texts.find { |t| t.x == y4.x and t.y == @num_y3 }
      if (not tbase3.nil?) and tbase3.text == y4.text
        tbase3.text = tbase3.text.to_i * 2
        tbase3.color = @merged_color
        y4.remove
        @texts.delete(y4)
      end
    end
  end

  # add up numbers when the down button is clicked, same as the command for up button. but add number in the reverse order and delete the upper cell
  def downwardly_merge_adjacent_nums
    texts_y3.each do |y3|
      tbase4 = @texts.find { |t| t.x == y3.x and t.y == @num_y4 }
      if (not tbase4.nil?) and tbase4.text == y3.text
        tbase4.text = tbase4.text.to_i * 2
        tbase4.color = @merged_color
        y3.remove
        @texts.delete(y3)
      end
    end
    texts_y2.each do |y2|
      tbase3 = @texts.find { |t| t.x == y2.x and t.y == @num_y3 }
      if (not tbase3.nil?) and tbase3.text == y2.text
        tbase3.text = tbase3.text.to_i * 2
        tbase3.color = @merged_color
        y2.remove
        @texts.delete(y2)
      end
    end
    texts_y1.each do |y1|
      tbase2 = @texts.find { |t| t.x == y1.x and t.y == @num_y2 }
      if (not tbase2.nil?) and tbase2.text == y1.text
        tbase2.text = tbase2.text.to_i * 2
        tbase2.color = @merged_color
        y1.remove
        @texts.delete(y1)
      end
    end
  end
  
  # add up numbers when the right button is clicked. same logic as the left button, but delete the left cell
  def rightwardly_merge_adjacent_nums
    texts_x3.each do |x3|
      tbase4 = @texts.find { |t| t.y == x3.y and t.x == @num_x4 }
      if (not tbase4.nil?) and tbase4.text == x3.text
        tbase4.text = tbase4.text.to_i * 2
        tbase4.color = @merged_color
        x3.remove
        @texts.delete(x3)
      end
    end
    texts_x2.each do |x2|
      tbase3 = @texts.find { |t| t.y == x2.y and t.x == @num_x3 }
      if (not tbase3.nil?) and tbase3.text == x2.text
        tbase3.text = tbase3.text.to_i * 2
        tbase3.color = @merged_color
        x2.remove
        @texts.delete(x2)
      end
    end
    texts_x1.each do |x1|
      tbase2 = @texts.find { |t| t.y == x1.y and t.x == @num_x2 }
      if (not tbase2.nil?) and tbase2.text == x1.text
        tbase2.text = tbase2.text.to_i * 2
        tbase2.color = @merged_color
        x1.remove
        @texts.delete(x1)
      end
    end
  end

  # move the numbers according to the command on the keyboard
  # move to the left
  def leftwardly_rearrange
    # x2 move to x1
    texts_x2.each do |x2|
      tbase1 = @texts.find { |t| t.y == x2.y and t.x == @num_x1 }
      x2.x = @num_x1 if tbase1.nil?
    end
    # x3 move to x2/x1, depend on whether the cell is empty
    texts_x3.each do |x3|
      tbase2 = @texts.find { |t| t.y == x3.y and t.x == @num_x2 }
      tbase1 = @texts.find { |t| t.y == x3.y and t.x == @num_x1 }
      x3.x = @num_x2 if tbase2.nil?
      x3.x = @num_x1 if tbase1.nil?
    end
    # x4 move to x3/x2/x1, depend on whether the cell is empty
    texts_x4.each do |x4|
      tbase3 = @texts.find { |t| t.y == x4.y and t.x == @num_x3 }
      tbase2 = @texts.find { |t| t.y == x4.y and t.x == @num_x2 }
      tbase1 = @texts.find { |t| t.y == x4.y and t.x == @num_x1 }
      x4.x = @num_x3 if tbase3.nil?
      x4.x = @num_x2 if tbase2.nil?
      x4.x = @num_x1 if tbase1.nil?
    end
  end

  # move up
  def upwardly_rearrange
    # y2 to y1
    texts_y2.each do |y2|
      tbase = @texts.find { |t| t.x == y2.x and t.y == @num_y1 }
      y2.y = @num_y1 if tbase.nil?
    end
    # y3 to y2/y1, depend on whether the cell is empty
    texts_y3.each do |y3|
      tbase2 = @texts.find { |t| t.x == y3.x and t.y == @num_y2 }
      tbase = @texts.find { |t| t.x == y3.x and t.y == @num_y1 }
      y3.y = @num_y2 if tbase2.nil?
      y3.y = @num_y1 if tbase.nil?
    end
    # y4 to y3/y2/y1, depend on whether the cell is empty
    texts_y4.each do |y4|
      tbase3 = @texts.find { |t| t.x == y4.x and t.y == @num_y3 }
      tbase2 = @texts.find { |t| t.x == y4.x and t.y == @num_y2 }
      tbase = @texts.find { |t| t.x == y4.x and t.y == @num_y1 }
      y4.y = @num_y3 if tbase3.nil?
      y4.y = @num_y2 if tbase2.nil?
      y4.y = @num_y1 if tbase.nil?
    end
  end

  # move downward
  def downwardly_rearrange
    # y3 to y4
    texts_y3.each do |y3|
      tbase4 = @texts.find { |t| t.x == y3.x and t.y == @num_y4 }
      y3.y = @num_y4 if tbase4.nil?
    end
    # y2 to y3/y4, depend on whether the cell is empty
    texts_y2.each do |y2|
      tbase4 = @texts.find { |t| t.x == y2.x and t.y == @num_y4 }
      tbase3 = @texts.find { |t| t.x == y2.x and t.y == @num_y3 }
      y2.y = @num_y3 if tbase3.nil?
      y2.y = @num_y4 if tbase4.nil?
    end
    # t1 to y2/y3/t4, depend on whether the cell is empty
    texts_y1.each do |y1|
      tbase4 = @texts.find { |t| t.x == y1.x and t.y == @num_y4 }
      tbase3 = @texts.find { |t| t.x == y1.x and t.y == @num_y3 }
      tbase2 = @texts.find { |t| t.x == y1.x and t.y == @num_y2 }
      y1.y = @num_y2 if tbase2.nil?
      y1.y = @num_y3 if tbase3.nil?
      y1.y = @num_y4 if tbase4.nil?
    end
  end

  # move to the right
  def rightwardly_rearrange
    # x3 to x4
    texts_x3.each do |x3|
      tbase4 = @texts.find { |t| t.y == x3.y and t.x == @num_x4 }
      x3.x = @num_x4 if tbase4.nil?
    end
    # x2 to x3/x4, depend on whether the cell is empty
    texts_x2.each do |x2|
      tbase4 = @texts.find { |t| t.y == x2.y and t.x == @num_x4 }
      tbase3 = @texts.find { |t| t.y == x2.y and t.x == @num_x3 }
      x2.x = @num_x3 if tbase3.nil?
      x2.x = @num_x4 if tbase4.nil?
    end
    # x1 to x2/x3/x4, depend on whether the cell is empty
    texts_x1.each do |x1|
      tbase4 = @texts.find { |t| t.y == x1.y and t.x == @num_x4 }
      tbase3 = @texts.find { |t| t.y == x1.y and t.x == @num_x3 }
      tbase2 = @texts.find { |t| t.y == x1.y and t.x == @num_x2 }
      x1.x = @num_x2 if tbase2.nil?
      x1.x = @num_x3 if tbase3.nil?
      x1.x = @num_x4 if tbase4.nil?
    end
  end

end

# run the game
g = Game2048.new
g.run