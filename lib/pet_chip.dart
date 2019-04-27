import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store/bloc/shoppingcart_event.dart';
import 'package:pet_store/pet.dart';
import 'package:pet_store/styles.dart';
import 'bloc/shoppingcart_bloc.dart';

class PetChip extends StatefulWidget {
  const PetChip(this.pet);

  final Pet pet;

  @override
  _PetChipState createState() => _PetChipState();
}

class _PetChipState extends State<PetChip> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // remove Pet from shopping cart
        ShoppingCartBloc _scBloc = BlocProvider.of(context);
        _scBloc.dispatch(RemovePet(widget.pet));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.pet.name,
              style: chipTextStyle,
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              Icons.close,
              size: 14,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
