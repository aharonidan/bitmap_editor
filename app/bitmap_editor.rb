require './app/bitmap'

class BitmapEditor

  attr_reader :image, :command, :args

  COMMANDS =
    {
      'I' => { format: /^I \d+ \d+$/, method: :create_image },
      'C' => { format: 'C', method: :clear_table, image_required: true },
      'L' => { format: /^L \d+ \d+ [A-Z]$/, method: :colour_pixel, image_required: true },
      'V' => { format: /^V \d+ \d+ \d+ [A-Z]$/, method: :colour_vertical, image_required: true },
      'H' => { format: /^H \d+ \d+ \d+ [A-Z]$/, method: :colour_horizontal, image_required: true },
      'S' => { format: 'S', method: :print, image_required: true },
      'X' => { format: 'X', method: :exit_console },
      '?' => { format: /^\?$/, method: :show_help },
    }

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      validate_and_run(gets.chomp)
    end
  end

  private
    def validate_and_run(input)
      validate(input)
      run_command
    rescue ArgumentError => error
      puts error.message
    ensure
      reset_command
    end

    def validate(input)
      option, *@args = input.split
      current_command = COMMANDS[option]

      if command_format_matches?(input, current_command)
        @command = current_command
      end

      if unrecognised_command?
        raise ArgumentError, 'unrecognised command :('
      elsif image_is_missing?
        raise ArgumentError, 'image required for this operation :('
      end
    end

    def run_command
      run_on = command[:image_required] ? image : self
      run_on.send(command[:method], *args)
    end

    def command_format_matches?(input, current_command)
      current_command && input.match(current_command[:format])
    end

    def reset_command
      @command = nil
    end

    def unrecognised_command?
      command == nil
    end

    def image_is_missing?
      image == nil && command[:image_required]
    end

    def create_image(columns, rows)
      @image = Bitmap.new(columns.to_i, rows.to_i)
    end

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
