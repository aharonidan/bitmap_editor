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
end