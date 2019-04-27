/*
 * If anyone is ever reading this...
 * I've never implemented BLoC before.
 * Please forward any and all complaints
 * to your Mom's house.
 * 
 * If you're interested in BLoC,
 * https://www.youtube.com/watch?v=LeLrsnHeCZY &
 * https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/
 * were extremely beneficial.
 */

import 'package:pet_store/pet.dart';

class ShoppingCartState {
  double total;
  List<Pet> basket;

  ShoppingCartState(this.basket, this.total);

  factory ShoppingCartState.inital() {
    return ShoppingCartState([], 0);
  }
}
