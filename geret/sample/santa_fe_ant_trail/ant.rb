
class Ant

  Food = '*'
  Empty = '.'

  Left = { :north => :west, :west => :south, :south => :east, :east => :north }
  Right = { :north => :east, :east => :south, :south => :west, :west => :north }
  DirX = { :north => 0, :west => -1, :south => 0, :east => 1 } 
  DirY = { :north => -1, :west => 0, :south => 1, :east => 0 }
  Avatar = { :north => '^', :west => '<', :south => 'v', :east => '>' }

  def initialize
    @grid = []
    IO.read( "#{File.dirname(__FILE__)}/trail.txt" ).each_line do |line| 
      @grid << line.sub(/\n/,'').split( // )
    end
    @grid_height = @grid.size
    @grid_width = @grid.first.size

    @dir = :south
    @x, @y = 0, 0
    @consumed_food = 0
  end

  attr_reader :consumed_food, :x, :y, :dir

  def move
    @x, @y = ahead_x, ahead_y  
    return unless @grid[@y][@x] == Food
    @consumed_food += 1
    @grid[@y][@x] = Empty
  end

  def right
    @dir = Right[ @dir ]
  end

  def left
    @dir = Left[ @dir ]
  end

  def food_ahead
    Food == @grid[ ahead_y ][ ahead_x ]
  end

  def show_scene
    scene = ''
    @grid.each_with_index do |line,y|
      line.each_with_index do |field,x|
        scene += ( @x == x and @y == y ) ? Avatar[@dir] : field
      end
      scene += "\n" 
    end
    scene
  end

  protected

  def ahead_x
    ( @x + DirX[@dir] ).divmod( @grid_width ).last
  end

  def ahead_y
    ( @y + DirY[@dir] ).divmod( @grid_height ).last
  end

end

