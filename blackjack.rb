# File  :  blackjack.rb
# Author:  RM2
#
# Assignment Week #1


#====================================================
# Globals
#====================================================

CardsPerDeck = 52
$numberOfDecks = Random.rand(1..7)
$totalCards = $numberOfDecks * CardsPerDeck
$dealerName = "Dealer"
$playerName = ""
PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
$gamesPlayed = {
    :count => 0,
    :wins => {
        :player => 0,
        :dealer => 0
    },
    :ties => 0
}

#====================================================
def initMatchStart()
#====================================================
    notDone = true
    while (notDone == true) do
        puts "Enter player's name:  "
        $playerName = gets
        $playerName = $playerName.chomp()
        if ($playerName.empty? == true)
            puts "You failed to enter a name; try again."
        else
            notDone = false
        end
    end

end # initMatchStart()

#====================================================
def decideToContinuePlay()
#====================================================
    notDone = true
    invalidEntry = true
    while (invalidEntry == true) do
        puts "Do you wish to play another game (Y/N)?"
        answer = gets
        answer = answer.chomp()
        if ((answer == "Y") or
            (answer == "y"))
            invalidEntry = false
        elsif ((answer == "N") or
               (answer == "n"))
            invalidEntry = false
            notDone = false
        end
    end
    return notDone

end # decideToContinueToPlay()

#====================================================
def mayGameContinue(game, person)
#====================================================
    result = true
    points = 0
    if (game[:player] == nil)
        game[:player] =  PersonData.new(Array.new, 0, false, false, false)
    end
    if (game[:dealer] == nil)
        game[:dealer] =  PersonData.new(Array.new, 0, false, false, false)
    end
    if (person == :player)
        points = game[:player].points
    else
        points = game[:dealer].points
    end
    if (points > 21)
        if (person == :player)
            game[:player].loss = true
            game[:dealer].win = true
            game[:winner] = :dealer
        else
            game[:dealer].loss = true
            game[:player].win = true
            game[:winner] = :player
        end
        result = false
    elsif (points == 21)
        game[:winner] = person
        if (person == :player)
            game[:dealer].loss = true
            game[:player].win = true
            game[:winner] = :player
        else
            game[:player].loss = true
            game[:dealer].win = true
            game[:winner] = :dealer
        end
        winHash = $gamesPlayed[:wins]
        if (person == :player)
            winHash[:player] = winHash[:player] + 1
        else
            winHash[:dealer] = winHash[:dealer] + 1
        end
        $gamesPlayed[:wins] = winHash
        result = false
      end
      return result

end # mayGameContinue()

#====================================================
def pickCard()
#====================================================
    cardOptions = Hash.new
    cardOptions[1] = :CA
    cardOptions[2] = :C2
    cardOptions[3] = :C3
    cardOptions[4] = :C4
    cardOptions[5] = :C5
    cardOptions[6] = :C6
    cardOptions[7] = :C7
    cardOptions[8] = :C8
    cardOptions[9] = :C9
    cardOptions[10] = :C10
    cardOptions[11] = :CJ
    cardOptions[12] = :CQ
    cardOptions[13] = :CK

    suits = Hash.new
    suits[1] = "clubs"
    suits[2] = "diamonds"
    suits[3] = "hearts"
    suits[4] = "spades"

    cardValues = Hash.new
    cardValues[:CA] = 1
    cardValues[:C2] = 2
    cardValues[:C3] = 3
    cardValues[:C4] = 4
    cardValues[:C5] = 5
    cardValues[:C6] = 6
    cardValues[:C7] = 7
    cardValues[:C8] = 8
    cardValues[:C9] = 9
    cardValues[:C10] = 10
    cardValues[:CJ] = 10
    cardValues[:CQ] = 10
    cardValues[:CK] = 10

    cardFaces = 13
    cardNumberPicked = Random.rand(1..$totalCards);

  # determine what deck we are in
    r = (cardNumberPicked % CardsPerDeck) + 1 # 1..52

  # determine the suit
  q = r/13  # want q: 1..4
  if (q < 4)
      q = q + 1
  end
  suit = suits[q]

  # determine the card
  card = Struct.new(:card, :suit, :value)
  c = (r % cardFaces) + 1 # 1..13
  cardSelected = cardOptions[c]
  cardValue = cardValues[cardSelected]
  if (cardSelected == :CA)
      whichAce = Random.rand(0..1)
      if (whichAce == 0)
          cardValue = 1
      else
          cardValue = 11
      end
  end
  oneCard = card.new(cardSelected, suit, cardValue)
  return oneCard

end # pickCard()

#====================================================
def handleOneCard(game, person)
#====================================================
    personData = nil
    if (person == :player)
        personData = game[:player]
    else
        personData = game[:dealer]
    end
    oneCard = pickCard()
    personData.allCards.push(oneCard)
    personData.points = personData.points + oneCard.value
    if (person == :player)
        game[:player] = personData
    else
        game[:dealer] = personData
    end

end # handleOneCard()

#====================================================
#  PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
#  Card = Struct.new(:card, :suit, :value);
#  GameData = {
#      :count => 0,
#	     :player => nil,
#	     :dealer => nil,
#	     :winner => nil
#  }
#
#  Game #  57
#      Fred wins
#	   Fred:  
#	       Points:
#		   Cards:
#	   Dealer:  
#	       Points:
#	       Cards:
#====================================================
def showGameResults(game)
#====================================================
    cardNames = Hash.new
    cardNames[:CA] = "Ace"
    cardNames[:C2] = "Two"
    cardNames[:C3] = "Three"
    cardNames[:C4] = "Four"
    cardNames[:C5] = "Five"
    cardNames[:C6] = "Six"
    cardNames[:C7] = "Seven"
    cardNames[:C8] = "Eight"
    cardNames[:C9] = "Nine"
    cardNames[:C10] = "Ten"
    cardNames[:CJ] = "Jack"
    cardNames[:CQ] = "Queen"
    cardNames[:CK] = "King"
    puts "Game # " + game[:count].to_s
    if (game[:winner] == :player)
        puts $playerName + " wins"
    else
        puts "Dealer wins"
    end
    #
    puts $playerName + ":"
    puts "\tPoints: " + game[:player].points.to_s
    puts "\tCards: "
    playerCards = game[:player].allCards
    count = 0
    while (count < playerCards.length) do
        oneCard = playerCards[count]
        puts "\t\t" + cardNames[oneCard.card] + " of " + oneCard.suit
        count = count + 1
    end
    #
    puts "Dealer:"
    puts "\tPoints: " + game[:dealer].points.to_s
    if (game[:dealer].points == 0)
        puts "\tCards: none"
    else
        puts "\tCards: "
        dealerCards = game[:dealer].allCards
        count = 0
        while (count < dealerCards.length) do
            oneCard = dealerCards[count]
            puts "\t\t" + cardNames[oneCard.card] + " of " + oneCard.suit
            count = count + 1
        end
    end

end # showGameResults()

#====================================================
#  PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
#  GameData = {
#      :count => 0, 
#	     :player => nil,
#	     :dealer => nil,
#	     :winner => nil
#  }
#====================================================
def proceedWithPlayer(game)
#====================================================
    invalidEntry = true
    continueToPlay = true
    while (invalidEntry == true) do
        puts $playerName + ", you have " + game[:player].points.to_s + " points."
        notDone = true
        while (notDone == true) do
            puts "Do you want another card (Y/N)?"
            answer = gets
            answer = answer.chomp()
            if ((answer == "Y") or
                (answer == "y"))
                 invalidEntry = false
                 handleOneCard(game, :player)
                 continueToPlay = mayGameContinue(game, :player)
                 notDone = false
            elsif ((answer == "N") or
                   (answer == "n"))
                invalidEntry = false
                notDone = false
            end
        end
    end
    return continueToPlay

end #proceedWithPlayer()

#====================================================
#  PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
#  GameData = {
#      :count => 0, 
#	   :player => nil, 
#	   :dealer => nil, 
#	   :winner => nil
# }
#====================================================
def proceedWithDealer(game)
#====================================================
    invalidEntry = true
    continueToPlay = true
    while (invalidEntry == true) do
        puts "Dealer you have " + game[:dealer].points.to_s + " points."
        notDone = true
        while (notDone == true) do
            puts "Do you want another card (Y/N)?"
            answer = gets
            answer = answer.chomp()
            if ((answer == "Y") or
                (answer == "y"))
                invalidEntry = false
                handleOneCard(game, :dealer)
                continueToPlay = mayGameContinue(game, :dealer)
                notDone = false
             elsif ((answer == "N") or
                    (answer == "n"))
                 invalidEntry = false
                 notDone = false
            end
        end
     end
     return continueToPlay

end # proceedWithDealer()

#====================================================
#  PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
#  GameData = {
#      :count => 0, 
#	     :player => nil,
#	     :dealer => nil,
#	     :winner => nil
#  }
#====================================================
def determineGameResults(game)
#====================================================
    playerPoints = game[:player].points
    dealerPoints = game[:dealer].points
    winHash = $gamesPlayed[:wins]
    if (dealerPoints == playerPoints)
        game[:winner] = nil  # tie
        $gamesPlayed[:ties] = $gamesPlayed[:ties] + 1
    elsif (dealerPoints < playerPoints)
        game[:winner] = :player
        game[:player].win = true
        game[:dealer].loss = true
        winHash[:player] = winHash[:player] + 1
  else
      game[:winner] = :dealer
      game[:dealer].win = true
      game[:player].loss = true
      winHash[:dealer] = winHash[:dealer] + 1
  end
  $gamesPlayed[:wins] = winHash

end # determineGameResults()

#====================================================
# The dealer must initially draw cards until he 
# has at least 17 points (forget the "she" political correctness).
#====================================================
def dealerMustMeetPointMinimum(game)
#====================================================
    notDone = true
    continueToPlay = true
    while (notDone == true) do
        if (game[:dealer].points  < 17)
            handleOneCard(game, :dealer)
            continueToPlay = mayGameContinue(game, :dealer)
        else
            notDone = false
        end
    end
    return continueToPlay

end # dealerMustMeetPointMinimum()

#====================================================
def startGame(game)
#====================================================
    playerData = PersonData.new(Array.new, 0, false, false, false)
    game[:player] = playerData
    handleOneCard(game, :player)
    handleOneCard(game, :player)
    continueToPlay =  mayGameContinue(game, :player)
    if (continueToPlay == false)
        showGameResults(game)
    else
        dealerData = PersonData.new(Array.new, 0, false, false, false)
        game[:dealer] = dealerData
        handleOneCard(game, :dealer)
        handleOneCard(game, :dealer)
        continueToPlay =  mayGameContinue(game, :dealer)
        if (continueToPlay == true)
            continueToPlay = dealerMustMeetPointMinimum(game)
        end
    end # else, if
    return continueToPlay

end # startGame()

#====================================================
def finishGame(game)
#====================================================
    continueToPlay = proceedWithPlayer(game)
    if (continueToPlay == false)
        showGameResults(game)
    else
        continueToPlay = proceedWithDealer(game)
    end
    if (continueToPlay == false)
        showGameResults(game)
    else
        determineGameResults(game)
        showGameResults(game)
    end

end # finishGame()

#====================================================
#  PersonData = Struct.new(:allCards, :points, :win, :loss, :tie)
#  GameData = {
#     :count => 0, 
#	    :player => nil,
#	    :dealer => nil,
#	    :winner => nil
#  }
#====================================================
def playOneGame(gameCount)
#====================================================
    oneGame = {
        :count => gameCount,
        :player => nil,
        :dealer => nil,
        :winner => nil
  }
  $gamesPlayed[:count] = gameCount
  continueToPlay = startGame(oneGame)
  if (continueToPlay == false)
      showGameResults(oneGame)
  else
      finishGame(oneGame)
  end

end # playOneGame()

#====================================================
#   Final Results:
#
#   Floyd wins the match
#
#   Player games won:
#	Dealer games won:
#	Ties            :
#====================================================
def showFinalResults()
#====================================================
    puts "Final Results:"
    puts "\n"
    winHash = $gamesPlayed[:wins]
    playerPoints = winHash[:player]
    dealerPoints = winHash[:dealer]
    if (playerPoints == dealerPoints)
        puts "The match ended in a tie"
    elsif (playerPoints < dealerPoints)
        puts $playerName + " wins the match"
    else
        puts "Dealer wins the match"
    end
    puts "\n"
    puts $playerName + " games won: " + playerPoints.to_s
    puts "Dealer games won: " + dealerPoints.to_s
    puts "Ties: " + $gamesPlayed[:ties].to_s

end # showFinalResults()

#====================================================
def playMatch()
#====================================================
    notDone = true
    gameCount = 0
    while (notDone == true) do
        gameCount = gameCount + 1
        playOneGame(gameCount);
        notDone = decideToContinuePlay()
    end

end # playMatch()

#====================================================
def main()
#====================================================
    initMatchStart()
    playMatch()
    showFinalResults()

end # main()


if (__FILE__ == $0)

    main()

end # if
