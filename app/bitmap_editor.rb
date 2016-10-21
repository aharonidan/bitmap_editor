require './app/bitmap'
require 'pry'

class BitmapEditor

  attr_reader :image, :command, :args

  COMMANDS =
    {
      'I' => { num_of_args: 2, method: :create_image,},
      'C' => { num_of_args: 0, method: :clear_table, image_required: true  },
      'L' => { num_of_args: 3, method: :colour_pixel, image_required: true, colour: true },
      'H' => { num_of_args: 4, method: :colour_horizontal, image_required: true, colour: true },
      'V' => { num_of_args: 4, method: :colour_vertical, image_required: true, colour: true },
      'S' => { num_of_args: 0, method: :print, image_required: true },
      'X' => { num_of_args: 0, method: :exit_console},
      '?' => { num_of_args: 0, method: :show_help},
    }

  SIZE_LIMIT = 250

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      input = gets.chomp
      validate_and_run(input)
    end
  end

  private
    def validate_and_run(input)
      init(input)
      error_message = validate(input)
      if error_message.nil?
        run_command
      else
        puts error_message
      end
    end

    def init(input)
      option, *@args = input.split
      @command = COMMANDS[option]
    end

    def run_command
      if command[:image_required]
        image.send(command[:method], *args)
      else
        send(command[:method], *args)
      end
    end

    def validate(input)
      error_message = if command_not_found?
        'unrecognised command :('
      elsif wrong_number_arguments?
        'wrong number of arguments :('
      elsif image_is_missing?
        'image required for this operation :('
      elsif invalid_dimensions?
        'image dimensions error, dimensions must be between 1 and 250 :('
      elsif invalid_colour?
        'colour error, please specify colour by a capital letter'
      elsif index_out_of_bound?
        'index out of bound error :('
      end

      return error_message
    end

    def command_not_found?
      command == nil
    end

    def wrong_number_arguments?
      command[:num_of_args] != args.length
    end

    def image_is_missing?
      image == nil && command[:image_required]
    end

    def invalid_dimensions?
      command[:method] == :create_image && dimensions_out_of_range?
    end

    def dimensions_out_of_range?
      columns, rows = args.map(&:to_i)
      columns < 1 || columns > SIZE_LIMIT || rows < 1 || rows > SIZE_LIMIT
    end

    def invalid_colour?
      colour = args[-1]
      command[:colour] && !colour.match(/[A-Z]/)
    end


    def index_out_of_bound?
      case command[:method]
      when :colour_pixel
        invalid_index?(:columns, args[0]) || invalid_index?(:rows, args[1])
      when :colour_vertical
        invalid_index?(:columns, args[0]) || invalid_index?(:rows, args[1]) || invalid_index?(:rows, args[2])
      when :colour_horizontal
        invalid_index?(:columns, args[0]) || invalid_index?(:columns, args[1]) || invalid_index?(:rows, args[2])
      else
        false
      end
    end

    def invalid_index?(axis, index)
      index.to_i < 0 || index.to_i > image.send(axis)
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
