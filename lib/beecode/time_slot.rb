module Beecode
  class TimeSlot
    attr_reader :t_start, :t_end, :beecode_id, :price

    def initialize(t_start, t_end, price, id = nil)
      @t_start = t_start.strftime("%d/%m/%Y %H:%M")
      @t_end = t_end.strftime("%d/%m/%Y %H:%M")
      @price = price
      @beecode_id = id
    end

    def serialize
      h = {start: @t_start, end: @t_end, price: @price}
      h[:id] = @id unless @id.nil?
      h
    end
  end
end