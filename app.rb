# This was written on a phone in a pretty poor editor, hence it's all in one big file and the renderer is rubbish :)

class Game

  attr_reader :world, :ticks, :renderer

  def initialize(s,t)
    @world = World.new(s)
    @renderer = Renderer.new @world
    @ticks = t
  end

  def run!
    render
    ticks.times { tick;render }
  end

  def render
    renderer.render
  end

  def tick
    world.update
  end
end

class Renderer

  attr_reader :world

  def initialize(w)
    @world = w
  end

  def render
   puts "--------------"
   world.size.times do |x|
      row = ""
      world.size.times do |y|
        row += cell_view(
          world.grid[x][y])
      end
      puts row
    end
  end

  def cell_view(cell)
    cell.alive? ? '1' : '0'
  end
   
end

class Cell
  attr_reader :state

  def initialize
    kill
  end
  
  def alive?
    state == :alive
  end

  def kill
    @state = :dead
  end

  def vivify
    @state = :alive
  end
end

class World
  attr_reader :grid, :size

  def initialize(s)
    @size = s

    reset
    seed
  end

  def reset
    @grid = new_grid
  end

  def update
    next_grid = new_grid
    size.times do |x|
      size.times do |y|
        if cell_alive?(x,y)
          next_grid[x][y].vivify
        end
      end
    end

    @grid = next_grid
  end

  def ref(n)
    (n % (size - 1))
  end

  def cell_alive?(x,y)
    tl = @grid[ref(x-1)][ref(y-1)]
    tm = @grid[ref(x)][ref(y-1)]
    tr = @grid[ref(x+1)][ref(y-1)]

    ml = @grid[ref(x-1)][ref(y)]
    mr = @grid[ref(x+1)][ref(y)]

    bl = @grid[ref(x-1)][ref(y+1)]
    bm = @grid[ref(x)][ref(y+1)]
    br = @grid[ref(x+1)][ref(y+1)]

    neighbours = [tl,tm,tr,ml,mr,bl,bm,br]

    total_alive = neighbours.reduce(0) do |m,o|
      m = m + 1 if o.alive?
      m
    end

    (total_alive > 1) && (total_alive < 4)
  end

  def seed
    size.times { |x|
      size.times { |y|
        grid[x][y].vivify if ( rand(0..1) > 0 )
      }
    }
  end


  def new_grid
    new_grid = []

    size.times {
      new_grid.push [] 
      size.times {
        new_grid.last.push Cell.new
      }
    }

    new_grid
  end
end

g = Game.new(10,5)
g.run!
