import 'dart:async';
import 'dart:math';

import 'package:deckofcards_api/common/util.dart';
import 'package:deckofcards_api/components/flipping_card_component.dart';
import 'package:deckofcards_api/components/hand_component.dart';
import 'package:deckofcards_api/components/player_points_component.dart';
import 'package:flutter/material.dart';
import 'package:deckofcards_api/service/deck_service.dart';

class BlackJackPage extends StatelessWidget {
  BlackJackPage({super.key});

  String deckId = "";
  int cardsRemaining = 52;
  String flippingCardImg = "";
  int flippingCardValue = 0;

  PlayerPoint dealerPoints = PlayerPoint();
  PlayerPoint playerPoints = PlayerPoint();

  Hand? dealerHand, playerHand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 82, 25),
      body: FutureBuilder(
        future: buildDeck(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      )
                    ],
                  ),
                ],
              );
            default:
              return mainPage(context, snapshot);
          }
        },
      ),
    );
  }

  Widget mainPage(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder(
          future: (deckId.isNotEmpty) ? listPile(deckId, "dealer") : null,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return dealerCards(context, snapshot);
              default:
                return Container();
            }
          }),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dealerPoints,
            Transform.rotate(
              angle: pi / 2,
              child: Image.network(
                'https://deckofcardsapi.com/static/img/back.png',
                scale: 2,
              ),
            ),
            playerPoints,
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            FutureBuilder(
              future: (deckId.isNotEmpty) ? listPile(deckId, "player") : null,
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return playerCards(context, snapshot);
                  default:
                    return Container();
                }
              }),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => hit(playerHand!, playerPoints, dealerPoints, "player", true),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 63, 3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  child: const Text(
                    "HIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: stand,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 63, 3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  child: const Text(
                    "STAND",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  List<Widget> createHandChildren(List cards, PlayerPoint pointer, int limit) {
    List<Widget> children = [const SizedBox(width: 10)];
    for (dynamic card in cards.take(limit)) {
      pointer.state.points += Util.getCardValue(card["value"]);
      children.addAll([
        Image.network(
          card["image"],
          scale: 2,
        ),
        const SizedBox(width: 10),
      ]);
    }
    return children;
  }

  List cardsDealerHand = [];
  Widget dealerCards(BuildContext context, AsyncSnapshot snapshot) {
    cardsDealerHand = snapshot.data["cards"].toList();
    List<Widget> children =
        createHandChildren(cardsDealerHand, dealerPoints, cardsDealerHand.length - 1);
    children.add(FlippingCard(flippingCardImg: flippingCardImg));
    children.add(const SizedBox(width: 10));
    dealerHand = Hand(children: children);
    return dealerHand ?? Container();
  }

  List cardsPlayerHand = [];
  Widget playerCards(BuildContext context, AsyncSnapshot snapshot) {
    cardsPlayerHand = snapshot.data["cards"].toList();
    List<Widget> children =
        createHandChildren(cardsPlayerHand, playerPoints, cardsPlayerHand.length);
    Timer(const Duration(milliseconds: 200), () => dealerPoints.state.updateState());
    Timer(const Duration(milliseconds: 200), () => playerPoints.state.updateState());
    playerHand = Hand(children: children);
    return playerHand ?? Container();
  }

  Future<int> setHands() async {
    if(cardsRemaining < 4){
      await returnFromPile(deckId, "discard");
      cardsRemaining = 48;
    }
    for (var i = 0; i < 2; i++) {
      Map cards = await drawCards(deckId, 1);
      await addToPile(deckId, "player", [cards["cards"][0]["code"]]);

      cards = await drawCards(deckId, 1);
      await addToPile(deckId, "dealer", [cards["cards"][0]["code"]]);
      flippingCardImg = cards["cards"][0]["image"];
      flippingCardValue = Util.getCardValue(cards["cards"][0]["value"]);

      cardsRemaining -= 2;
    }
    return 0;
  }

  Future<String> buildDeck(BuildContext context) async {
    if (deckId.isNotEmpty) {
      return deckId;
    }
    Map deck = await createDeck(1);
    deckId = deck["deck_id"];
    await setHands();
    return deckId;
  }

  Future<int> restartGame() async {
    Map pile = await listPile(deckId, "player");
    cardsPlayerHand = pile["cards"].toList();
    pile = await listPile(deckId, "dealer");
    cardsDealerHand = pile["cards"].toList();

    await addToPile(deckId, "discard",
        cardsPlayerHand.map((e) => e["code"] as String).toList());
    await addToPile(deckId, "discard",
        cardsDealerHand.map((e) => e["code"] as String).toList());

    playerHand?.state.removeChildren();
    dealerHand?.state.removeChildren();

    await setHands();

    pile = await listPile(deckId, "player");
    cardsPlayerHand = pile["cards"].toList();
    pile = await listPile(deckId, "dealer");
    cardsDealerHand = pile["cards"].toList();

    List<Widget> children =
        createHandChildren(cardsPlayerHand, playerPoints, cardsPlayerHand.length);
    playerHand?.state.addChildren(children);

    children =
        createHandChildren(cardsDealerHand, dealerPoints, cardsDealerHand.length - 1);
    children.add(FlippingCard(flippingCardImg: flippingCardImg));
    children.add(const SizedBox(width: 10));
    dealerHand?.state.addChildren(children);
    
    dealerPoints.state.updateState();
    playerPoints.state.updateState();

    return 0;
  }

  /// @reference - https://stackoverflow.com/questions/73170098/create-async-await-steps-with-timer-instead-of-future-delayed
  Future<int> hit(Hand hand, PlayerPoint point, PlayerPoint pointOpp, String pile, bool shouldStand) async {
    if (cardsRemaining == 0) {
      Map response = await returnFromPile(deckId, "discard");
      cardsRemaining = response["remaining"];
    }
    Map cards = await drawCards(deckId, 1);
    await addToPile(deckId, pile, [cards["cards"][0]["code"]]);
    hand.state
        .addChild(Image.network(cards["cards"][0]["image"], scale: 2));
    hand.state.addChild(const SizedBox(width: 10));
    point.state.addPoints(Util.getCardValue(cards["cards"][0]["value"]));
    if (point.state.points > 21) {
      point.state.addLose();
      pointOpp.state.addWin();
      if(shouldStand){
        stand();
        Completer completer = Completer();
        Timer(const Duration(milliseconds: 500), () => completer.complete());
        await completer.future;
      }
      // await restartGame();
    }
    cardsRemaining--;
    return 0;
  }

  void stand() async {
    FlippingCard.startAnimation();
    dealerPoints.state.addPoints(flippingCardValue);
    flippingCardValue = 0;
    // dealer logic
    while(dealerPoints.state.points < playerPoints.state.points && dealerPoints.state.points < 17 && playerPoints.state.points <= 21){
      await hit(dealerHand!, dealerPoints, playerPoints, "dealer", false);
    }

    if(dealerPoints.state.points > playerPoints.state.points && dealerPoints.state.points <= 21){
      dealerPoints.state.addWin();
      playerPoints.state.addLose();
    }else if(dealerPoints.state.points < playerPoints.state.points && playerPoints.state.points <= 21){
      playerPoints.state.addWin();
      dealerPoints.state.addLose();
    }else if(playerPoints.state.points <= 21 && dealerPoints.state.points <= 21){
      dealerPoints.state.addDraw();
      playerPoints.state.addDraw();
    }

    Completer completer = Completer();
    Timer(const Duration(milliseconds: 1500), () => completer.complete());
    await completer.future;

    dealerPoints.state.points = 0;
    playerPoints.state.points = 0;

    dealerPoints.state.updateState();
    playerPoints.state.updateState();

    FlippingCard.resetAnimation();
    await restartGame();
  }
}
