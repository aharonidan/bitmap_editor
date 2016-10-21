class Bitmap

  attr_reader :rows, :columns, :table

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @table = create_table
  end

  def create_table
    Array.new(rows) { Array.new(columns, 'O') }
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

  def colour_pixel(row, column, colour)
    table[row.to_i - 1][column.to_i - 1] = colour
  end

  def colour_horizontal(row, start_column, end_column, colour)
    (start_column..end_column).each do |column|
      colour_pixel(row, column, colour)
    end
  end

  def colour_vertical(start_row, end_row, column, colour)
    (start_row..end_row).each do |row|
      colour_pixel(row, column, colour)
    end
  end

end