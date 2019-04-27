import 'package:flutter/material.dart';
import 'package:pet_store/pet.dart';
import 'bloc/shoppingcart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSwitcher extends StatefulWidget {
  final void Function(bool e, Pet pet) onSwitch;
  final Pet pet;

  CustomSwitcher(this.onSwitch, this.pet);

  @override
  State<StatefulWidget> createState() => _CustomSwitcherState();
}

class _CustomSwitcherState extends State<CustomSwitcher>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CustomSwitcher> {
  static const double SWITCHER_HEIGHT = 35;
  static const double SWITCHER_WIDTH = 65;

  AnimationController _animationController;
  Animation<double> switcherProgress;
  Animation<Color> switcherBGProgress;

  bool isEnabled;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isEnabled = false;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 580),
    );

    switcherProgress = Tween<double>(begin: 8, end: 35).animate(
      CurvedAnimation(
        curve: Curves.easeOutCirc,
        parent: _animationController,
      ),
    );

    // override the init state of false if the pet is within the BLoC provider
    ShoppingCartBloc _scBloc = BlocProvider.of(context);
    _scBloc.currentState.basket.map((p) {
      if (widget.pet.name == p.name) {
        isEnabled = true;
      }
    });

    // add a listener in case the pet is removed
    _scBloc.state.listen((state) {
      for (Pet p in state.basket) {
        if (p.name == widget.pet.name) {
          return;
        }
      }

      isEnabled = false;
      if (isEnabled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (switcherBGProgress == null) {
      switcherBGProgress = ColorTween(
              begin: Theme.of(context).primaryColorDark,
              end: Theme.of(context).primaryColor)
          .animate(_animationController);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isEnabled = !isEnabled;

          if (isEnabled) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }

          widget.onSwitch(isEnabled, widget.pet);
        });
      },
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, __) {
              return Container(
                width: SWITCHER_WIDTH,
                height: SWITCHER_HEIGHT,
                decoration: BoxDecoration(
                  color: switcherBGProgress.value,
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            },
          ),
          Container(
            height: SWITCHER_HEIGHT,
            width: SWITCHER_WIDTH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return Container(
                      margin: EdgeInsets.only(
                        left: switcherProgress.value,
                      ),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
