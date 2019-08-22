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

  def csv(sep=',', encoding: nil)
    require 'csv'
    csv = {}
    csv[:encoding] = encoding + ":UTF-8" if encoding
    csv[:col_sep ] = sep
    csv = CSV.new($stdout, csv)
    csv << cols.keys
    rows.each {|vals| csv << vals}
  end
  def tsv; csv("\t"); end
  def psv; csv("|" ); end

  def sql(table='table', quote: false)
    q = quote ? '`' : ''
    flip = cols.invert
    rows.each do |vals|
      list = vals.each_with_index.inject([]) do |list, (item, i)|
        list << "#{q}#{flip[i]}#{q}='#{item.gsub("'","''")}'" if item =~ /\S/
        list
      end
      puts "insert into #{q}#{table}#{q} set #{list * ', '};" if !list.empty?
    end
  end
end
