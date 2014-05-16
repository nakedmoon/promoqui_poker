class Card
  attr_reader :suit
  attr_reader :value

  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

  def initialize(card)
    @suit = card[1]
    @value = VALUES.index(card[0])
  end
end


class Cards

  attr_reader :values
  attr_reader :suits
  attr_reader :counts
  attr_reader :result

  PARTIALS = [:pair, :two_pairs, :three_of_a_kind, :straight, :flush, :full_house, :four_of_a_kind, :straight_flush]

  def initialize(cards = ['2C','2S','9H','AC','KD'])
    @cards = cards.map{|c| Card.new(c)}
    @values = @cards.map(&:value)
    @suits = @cards.map(&:suit)
    @counts = {:values => {}, :suits => {}}
    @values.uniq.each{|v| @counts[:values][v] = @values.count(v)}
    @suits.uniq.each{|s| @counts[:suits][s] = @suits.count(s)}
    @result = {:partial => -1, :rank => []}
    self.check_rank
  end

  def check_rank
    PARTIALS.reverse.each do |partial|
      puts partial
      rank = self.send("#{partial}_rank")
      @result = {:partial => PARTIALS.index(partial), :rank => [rank].flatten} and break unless rank.nil?
    end
  end

  def count_values(*n)
    @counts[:values].select{|v,c| n.include?(c)}
  end

  def count_suits(*n)
    @counts[:suits].select{|v,c| n.include?(c)}
  end

  def sequential
    b = @values.dup
    x = b.delete(b.min)
    nil while b.delete(x+=1)
    return b.empty? ? @values.max : nil
  end

  def straight_flush_rank
    result = sequential
    return count_suits(5).empty? ? nil : result
  end

  def four_of_a_kind_rank
    result = count_values(4)
    return result.empty? ? nil : result.keys.first
  end

  def full_house_rank
    result = count_values(3,2)
    return result.size==2 ? result.key(3) : nil
  end

  def flush_rank
    result = count_suits(5)
    return result.empty? ? nil : @values.sort.reverse.uniq
  end

  def straight_rank
    return sequential
  end

  def three_of_a_kind_rank
    result = count_values(3)
    return result.empty? ? nil : result.keys.first
  end

  def pair_rank
    result = count_values(2)
    return result.empty? ? nil : result.keys.first
  end

  def two_pairs_rank
    result = count_values(2)
    return result.size == 2 ? result.keys.max : nil
  end


end


class Hand

  attr_reader :player1
  attr_reader :player2
  attr_reader :winner


  def initialize(player1 = ['2C','3S','9H','AC','KD'], player2 = ['2C','3S','9H','AC','KD'])
    @player1 = Cards.new(player1)
    @player2 = Cards.new(player2)
  end

  def compare_result
    if @player1.result[:partial] > @player2.result[:partial]
      @winner = @player1
    elsif @player1.result[:partial] < @player2.result[:partial]
      @winner = @player2
    else
      @winner = compare_ranks
    end
  end


  def compare_ranks
    result = nil
    @player1.result[:rank].each_with_index do |rank,idx|
      if rank > @player2.result[:rank][idx]
        result = @player1 and break
      elsif rank < @player2.result[:rank][idx]
        result = @player2 and break
      end
    end
    return result
  end


















end