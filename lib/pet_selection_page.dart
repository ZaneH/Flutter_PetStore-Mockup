import 'package:flutter/material.dart';
import 'package:pet_store/bloc/shoppingcart_event.dart';
import 'package:pet_store/pet.dart';
import 'styles.dart';
import 'custom_switcher.dart';
import 'bloc/shoppingcart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pet_chip.dart';

class PetSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PetSelectionPageState();
}

class _PetSelectionPageState extends State<PetSelectionPage> {
  List<Widget> petCards;

  int _currentCard = 0;
  PageController _pc;

  @override
  void initState() {
    super.initState();

    petCards = [];
    _currentCard = 0;
    _pc = PageController(viewportFraction: 0.88);
  }

  // this builds the PageView and even its containing parent
  _buildPetChooserCards(BuildContext context) {
    // fn-ception so that we can use the provided context– Dart is wow.
    _buildPetCard(Pet pet) {
      final ShoppingCartBloc _scBloc =
          BlocProvider.of<ShoppingCartBloc>(context);

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.125),
              blurRadius: 16,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    pet.name,
                    style: h1TextStyle,
                  ),
                  Spacer(),
                  CustomSwitcher((e, petObject) {
                    if (e) {
                      // if the switch is turned on, add the petObject
                      _scBloc.dispatch(AddPet(petObject));
                    } else {
                      // otherwise, remove the petObject
                      _scBloc.dispatch(RemovePet(petObject));
                    }
                  }, pet),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '\$${pet.price.toStringAsFixed(2)}',
                style: h3TextStyle,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Tax Included',
                style: h4TextStyle,
              ),
            ],
          ),
        ),
      );
    }

    petCards.clear();

    // dummy data, this could be a server request
    petCards.add(_buildPetCard(Pet("Dog", 15)));
    petCards.add(_buildPetCard(Pet("Fish", 5)));
    petCards.add(_buildPetCard(Pet("Cat", 15)));
    petCards.add(_buildPetCard(Pet("Piglet", 20)));
    petCards.add(_buildPetCard(Pet("Dragon", 115)));

    return SizedBox.fromSize(
      size: Size(MediaQuery.of(context).size.width, 200),
      child: PageView.builder(
        controller: _pc
          ..addListener(() {
            // if the card ever fully changes, setState to update dot indicators
            setState(() {
              _currentCard = _pc.page.round();
            });
          }),
        itemCount: petCards.length,
        itemBuilder: (_, idx) {
          return petCards[idx];
        },
      ),
    );
  }

  _buildPetChips(List<Pet> basket) {
    if (basket.length <= 0) {
      return Container();
    }

    return Container(
      child: Wrap(
        children: basket.map((p) {
          return PetChip(p);
        }).toList(),
      ),
    );
  }

  _buildTotal(double total) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Total", style: h3TextStyle),
            Spacer(),
            Text(
              total == 0 || total == null
                  ? "\$ --"
                  : "\$${total.toStringAsFixed(2)}",
              style: bigTotalTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Tax Included",
              style: pTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  _buildPetCheckoutCard(BuildContext context) {
    ShoppingCartBloc _scBloc = BlocProvider.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
      child: SizedBox.fromSize(
        size: Size(MediaQuery.of(context).size.width, 220),
        child: Container(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildPetChips(_scBloc.currentState.basket),
                (_scBloc.currentState.basket.length > 0)
                    ? (Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Divider(
                          height: 1,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ))
                    : Container(),
                Expanded(
                  child: Container(),
                ),
                _buildTotal(_scBloc.currentState.total),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.125),
                blurRadius: 16,
                offset: Offset(3, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardIndicatorsAndSearch() {
    _buildDot(bool isActive) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorDark,
        ),
      );
    }

    List<Widget> dots = [];

    if (petCards.length > 0) {
      for (int i = 0; i < petCards.length; i++) {
        if (_pc.hasClients) {
          dots.add(_buildDot(_currentCard == i));
        } else {
          // select the first one, always
          if (i == 0) {
            dots.add(_buildDot(true));
          } else {
            dots.add(_buildDot(false));
          }
        }

        dots.add(
          SizedBox(
            width: 6,
          ),
        );
      }
    }
    return Row(
      children: dots
        // just add the search to the end of the dots
        ..addAll(
          [
            Spacer(),
            Text("Search", style: bTextStyle),
            SizedBox(
              width: 4,
            ),
            Icon(Icons.search),
          ],
        ),
    );
  }

  _buildBottomButtons() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 36,
          vertical: 24,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Payment Plans", style: iButtonStyle),
                        SizedBox(width: 8,),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // listener for BLoC changes
    ShoppingCartBloc _scBloc = BlocProvider.of(context);
    _scBloc.state.listen((state) {
      setState(() {
        // we don't need to do anything
        // flutter rebuilds all the needed widgets
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFCFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SafeArea(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pet Store",
                  textAlign: TextAlign.left,
                  style: h1TextStyle,
                ),
                Text(
                  "If you want it, we might have it.",
                  textAlign: TextAlign.left,
                  style: pTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _buildPetChooserCards(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 44, vertical: 8),
            child: _buildCardIndicatorsAndSearch(),
          ),
          _buildPetCheckoutCard(context),
          Expanded(
            child: Container(),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }
}
