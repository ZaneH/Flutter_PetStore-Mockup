import 'package:bloc/bloc.dart';
import 'package:pet_store/bloc/shoppingcart_state.dart';
import 'package:pet_store/bloc/shoppingcart_event.dart';
import 'package:pet_store/pet.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  @override
  get initialState => ShoppingCartState.inital();

  @override
  Stream<ShoppingCartState> mapEventToState(ShoppingCartEvent event) async* {
    if (event is AddPet) {
      yield* _mapAddPetToState(event);
    } else if (event is RemovePet) {
      yield* _mapRemovePetToState(event);
    }
  }

  Stream<ShoppingCartState> _mapAddPetToState(AddPet event) async* {
    final List<Pet> updatedCart = List.from(currentState.basket)
      ..add(event.pet);

    double runningTotal = 0;
    for (Pet p in updatedCart) {
      runningTotal += p.price;
    }

    yield ShoppingCartState(updatedCart, runningTotal);
  }

  Stream<ShoppingCartState> _mapRemovePetToState(RemovePet event) async* {
    final List<Pet> updatedCart = List.from(currentState.basket)
      ..removeWhere((a) {
        return (a.name == event.pet.name);
      });

    double runningTotal = 0;
    for (Pet p in updatedCart) {
      runningTotal += p.price;
    }

    yield ShoppingCartState(updatedCart, runningTotal);
  }
}
