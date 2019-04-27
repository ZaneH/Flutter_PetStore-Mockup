import 'package:pet_store/pet.dart';

abstract class ShoppingCartEvent {}

class AddPet extends ShoppingCartEvent {
  final Pet pet;

  AddPet(this.pet);
}

class RemovePet extends ShoppingCartEvent {
  final Pet pet;
  
  RemovePet(this.pet);
}