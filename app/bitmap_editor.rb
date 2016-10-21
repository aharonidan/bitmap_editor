require './app/bitmap'
class BitmapEditor


  COMMANDS =
    {
      'I' => { number_of_args: 2, method: :create_table, image_required: false },
      'C' => { number_of_args: 0, method: :clear_table, image_required: true  },
      'L' => { number_of_args: 3, method: :colour_pixel, image_required: true  },
      'H' => { number_of_args: 3, method: :colour_row, image_required: true  },
      'V' => { number_of_args: 3, method: :colour_column, image_required: true  },
      'S' => { number_of_args: 0, method: :print, image_required: true  },
      'X' => { number_of_args: 0, method: :exit_console, image_required: false  },
      '?' => { number_of_args: 0, method: :show_help, image_required: false  },
    }

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      input = gets.chomp
      case input
        when '?'
          show_help
        when 'X'
          exit_console
        else
          puts 'unrecognised command :('
      end
    end
  end

  private
    def exit_console
      puts 'goodbye!'
      @running = false
    end

    def show_help
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
