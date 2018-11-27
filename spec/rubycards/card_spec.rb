require 'spec_helper'

include RubyCards

describe Card do
  describe '#initialize' do
    context 'no params' do
      it 'should return the ace of spades' do
        new_card = Card.new
        expect(new_card.suit).to eq 'Spades'
        expect(new_card.rank).to eq 'Ace'
      end
    end

    context 'params' do
      it 'should return the card specified in params' do
        new_card = Card.new('Queen', 'Clubs')
        expect(new_card.rank).to eq 'Queen'
        expect(new_card.suit).to eq 'Clubs'

        new_card = Card.new(3, 'Spades')
        expect(new_card.rank).to eq '3'
        expect(new_card.suit).to eq 'Spades'

        new_card = Card.new('Jack', 'Diamonds')
        expect(new_card.rank).to eq 'Jack'
        expect(new_card.suit).to eq 'Diamonds'

        new_card = Card.new(7, 'Hearts')
        expect(new_card.rank).to eq '7'
        expect(new_card.suit).to eq 'Hearts'
      end
    end
  end

  describe '#comparator' do
    let (:king) { Card.new('King','Clubs') }
    let (:queen) { Card.new('Queen','Clubs') }
    let (:jack) { Card.new('Jack','Clubs') }
    let (:high_ace) { Card.new('Ace','Clubs', aces_high: true) }
    let (:low_ace) { Card.new('Ace','Clubs', aces_high: false) }
    let (:c2) { Card.new(2,'Diamonds') }
    let (:c2_heart) { Card.new(2,'Hearts') }
    let (:c4) { Card.new(4,'Spades') }

    it 'should reflect the correct rank when compared' do
      expect(king).to be > queen
      expect(king).to be > jack
      expect(king).to eq king
      expect(king).to be < high_ace
      expect(king).to be > low_ace

      expect(low_ace).to be < c2_heart

      expect(jack).not_to be > queen
      expect(jack).not_to be > high_ace
      expect(jack).to be < queen

      expect(high_ace).not_to be < queen
      expect(high_ace).to be > c4

      expect(c2).to be < c4
      expect(c2_heart).to eq c2
    end
  end

  describe '#rank' do
    context 'face cards' do
      let (:king) { Card.new('King', 'Clubs') }

      it 'should return a long rank' do
        expect(king.rank).to eq 'King'
      end

      it 'should return a short rank' do
        expect(king.rank(true)).to eq 'K'
      end
    end

    context 'numeric cards' do
      let (:num) { Card.new(10, 'Diamonds') }

      it 'should have the same long and short rank' do
        expect(num.rank).to eq num.rank(true)
      end
    end
  end

  describe '#display' do
    BORDER_COUNT = 18 # the number of unicode characters on the border
    RANKS = [*2..10, 'Jack', 'Queen', 'King', 'Ace']

    it 'should have the correct number of glyphs' do
      RANKS.each do |rank|
        card = Card.new(rank, 'hearts')   # rspec doesn't play nice with dark cards
        glyph_count = card.to_s.scan(/[^\x00-\x7F]/).count

        if (2..10).include? card.rank.to_i
          expect(glyph_count).to eq card.rank.to_i + BORDER_COUNT
        else
          expect(glyph_count).to eq 2 + BORDER_COUNT
        end
      end
    end

    it 'should display #inspect the same as #short' do
      RANKS.each do |rank|
        card = Card.new(rank, 'diamonds')

        expect(card.inspect).to eq card.short
      end
    end
  end

  describe '#joker' do
    it 'should set suit and rank correctly' do
      joker1 = Card.new('Joker', 'Joker')
      joker2 = Card.new(nil,nil)

      expect(joker1.suit).to match 'Joker'
      expect(joker2.suit).to match 'Joker'
      expect(joker2.rank).to match 'Joker'
      expect(joker2.rank(true)).to match 'JR'
    end
  end

  describe "#same_as?" do
    it "should return true when the two different cards with the same suit/rank match" do
      deck1 = Deck.new
      deck2 = Deck.new
      deck1.cards.each_with_index do |_, index|
        expect(deck1[index]).to be_same_as deck2[index]
        expect(deck2[index]).to be_same_as deck1[index]
      end
    end

    it "should return false when compared to different cards" do
      deck1 = Deck.new
      deck2 = Deck.new
      deck1.cards.each_with_index do |_, index|
        expect(deck1[index]).not_to be_same_as deck2[index-1]
        expect(deck2[index]).not_to be_same_as deck1[index-1]
      end
    end
  end

end
