class TextTable
  attr_accessor :cols, :rows

  def initialize
    @cols = Hash.new{|h,k| h[k] = h.size}
    @rows = []
  end

  def add(hash)
    @rows << (vals = [])
    hash.each {|k, v| vals[@cols[k]] = v}
  end

  def show
    join = " | "
    both = [cols.keys] + rows
    flip = both.transpose
    wide = flip.map {|row| row.map {|col| col.to_s.size }.max }
    pict = wide.map {|len| "%-#{len}.#{len}s" }.join(join)
    pict = [join, pict, join].join.strip
    line = (pict % ([""] * cols.size)).tr("| ", "+-")
    seen = -1
    puts "", line
    both.each do |vals|
      puts pict % vals
      puts line if (seen += 1) == 0
    end
    puts line, "#{seen} rows displayed", ""
    self
  end
end
