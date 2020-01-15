class TextTable
  attr_accessor :values, :rows

  def initialize(*args)
    if args[0].is_a?(Array)
      cols, *rows = args
      rows = rows[0] if rows[0].is_a?(Array)
    else
      cols = args
      rows = []
    end
    @cols = Hash.new {|h,k| h[k] = h.size}
    @rows = rows
    @values = nil
    @row = 0
    cols.each {|col| index!(col) }
  end

  def index(field, auto=false)
    case field
    when String, Symbol
      field = convert_key(field)
      index = @cols.key?(field) ? @cols[field] : auto ? @cols[field] : nil
    when Numeric
      field
    else
      raise "invalid field index #{field.inspect}"
    end
  end

  def index!(field)
    index(field, true)
  end

  def convert_key(key)
    key.
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      gsub(/\W/, '_').
      downcase
  end

  def size
    @rows.size
  end

  def fields
    @cols.keys
  end

  def row(row=nil)
    row or return @row
    @values = @rows[@row = row]
    self
  end

  def row=(row)
    @values = @rows[@row = row]
    @row
  end

  def next!(step=1)
    row(@row += step) if @row < (size - step)
  end

  def prev!(step=1)
    row(@row -= step) if @row > 0
  end

  def vals
    @values ||= @rows[@row] ||= []
  end

  def each
    @rows or raise "no rows defined"
    @rows.each_with_index {|_, row| yield(row(row)) }
  end

  def [](field, val=nil)
    index = index(field)
    value = vals[index] if index
    value.nil? ? val : value
  end

  def []=(field, value)
    index = index!(field)
    vals[index] = value
  end

  def method_missing(field, *args)
    field = field.to_s
    equal = field.chomp!('=')
    index = index(field, equal)
    if equal
      value = vals[index] = args.first
    elsif index
      raise "variable lookup ignores arguments" unless args.empty?
      value = vals[index]
    end
    value
  end

  def add(obj, *args)
    obj = [obj, *args] if args.size > 0
    @values = @rows[@row = @rows.size] = []
    case obj
      when Hash  then obj.each {|k, v| @values[@cols[k]] = v}
      when Array then @values.replace(obj)
      else raise "unable to add #{obj.class} objects"
    end
    self
  end

  def show(*)
    self
  end

  def show!(list=nil)
    meth = list.is_a?(Array) ? list.method(:push) : method(:puts)
    join = " | "
    both = [@cols.keys] + rows
    flip = both.transpose
    wide = flip.map {|row| row.map {|col| col.to_s.size }.max }
    pict = wide.map {|len| "%-#{len}.#{len}s" }.join(join)
    pict = [join, pict, join].join.strip
    line = (pict % ([""] * @cols.size)).tr("| ", "+-")
    seen = -1
    meth["", line]
    both.each do |vals|
      meth[pict % vals]
      meth[line] if (seen += 1) == 0
    end
    meth[line, "#{seen} rows displayed", ""]
    self
  end

  def csv(sep=',', encoding: nil)
    require 'csv'
    csv = {}
    csv[:encoding] = encoding + ":UTF-8" if encoding
    csv[:col_sep ] = sep
    csv = CSV.new($stdout, csv)
    csv << @cols.keys
    @rows.each {|vals| csv << vals}
    nil
  end
  def tsv; csv("\t"); end
  def psv; csv("|" ); end

  def sql(table='table', quote: false)
    q = quote ? '`' : ''
    flip = @cols.invert
    @rows.each do |vals|
      list = vals.each_with_index.inject([]) do |list, (item, i)|
        item = item.to_s #!# FIXME: force all to a string for now...
        list << "#{q}#{flip[i]}#{q}='#{item.gsub("'","''")}'" if item =~ /\S/
        list
      end
      puts "insert into #{q}#{table}#{q} set #{list * ', '};" if !list.empty?
    end
    nil
  end
end

class ActiveRecord::Result
  def +@
    TextTable.new(columns, rows)
  end
end if defined?(ActiveRecord)
