require './app/bitmap'
class BitmapEditor

  attr_reader :image

  COMMANDS =
    {
      'I' => { number_of_args: 2, method: :create_image, image_required: false },
      'C' => { number_of_args: 0, method: :clear_table, image_required: true  },
      'L' => { number_of_args: 3, method: :colour_pixel, image_required: true  },
      'H' => { number_of_args: 4, method: :colour_horizontal, image_required: true  },
      'V' => { number_of_args: 4, method: :colour_vertical, image_required: true  },
      'S' => { number_of_args: 0, method: :print, image_required: true  },
      'X' => { number_of_args: 0, method: :exit_console, image_required: false  },
      '?' => { number_of_args: 0, method: :show_help, image_required: false  },
    }

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      run_command(gets.chomp)
    end
  end

  private
    def run_command(input)
      if command = validate_input(input)
        _, *args = input.split
        method = command[:method]

        if command[:image_required]
          image.send(method, *args)
        else
          send(method, *args)
        end

      end
    end


    def validate_input(input)
      result = nil
      option, *args = input.split
      command = COMMANDS[option]

      if command == nil
        puts 'unrecognised command :('
      elsif command[:number_of_args] != args.length
        puts 'wrong number of arguments :('
      elsif command[:image_required] && image == nil
        puts 'image required for this operation :('
      else
        result = command
      end

      return result
    end

    def exit_console(*args)
      puts 'goodbye!'
      @running = false
    end

    def create_image(m, n)
      @image = Bitmap.new(m.to_i, n.to_i)
    end

    def show_help(*args)
      puts "? - Help
I M N - Create a new M x N image with all pixels coloured white (O).
C - Clears the table, setting all pixels to white (O).
L X Y C - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
S - Show the contents of the current image
X - Terminate the session"
    end
end
