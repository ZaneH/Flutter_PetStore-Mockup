import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store/bloc/shoppingcart_bloc.dart';
import 'pet_selection_page.dart';

void main() => runApp(PetStore());

class PetStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorDark: Color(0xFF9A989B),
        primaryColorLight: Colors.white,
        primaryColor: Colors.black,
      ),
      home: BlocProvider(
        bloc: ShoppingCartBloc(),
        child: PetSelectionPage(),
      ),
    );
  }
}
