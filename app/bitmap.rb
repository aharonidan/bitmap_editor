class Bitmap

  attr_reader :rows, :columns, :table

  DEFAULT_COLOUR = 'O'
  SIZE_LIMIT = 250

  def initialize(columns, rows)
    validate_dimensions(columns, rows)
    @columns = columns
    @rows = rows
    @table = create_table
  end

  def validate_dimensions(columns, rows)
    if !columns.between?(1, SIZE_LIMIT) || !rows.between?(1, SIZE_LIMIT)
      raise ArgumentError, 'dimensions must be between 1 and 250 :('
    end
  end

  def create_table
    Array.new(rows) { Array.new(columns, DEFAULT_COLOUR) }
  end

  def clear_table
    @table = create_table
  end

  def print
    result = ''
    table.each do |row|
      row.each do |cell|
        result << cell + ' '
      end
      result << "\n"
    end
    puts result
  end

  def colour_pixel(column, row, colour)
    column, row = [column.to_i, row.to_i]
    if column > self.columns || row > self.rows
      raise ArgumentError, 'index out bound :('
    else
      table[row - 1][column - 1] = colour
    end
  end

  def colour_vertical(column, start_row, end_row, colour)
    (start_row..end_row).each do |row|
      colour_pixel(column, row, colour)
    end
  end

  def colour_horizontal(start_column, end_column, row, colour)
    (start_column..end_column).each do |column|
      colour_pixel(column, row, colour)
    end
  end
end