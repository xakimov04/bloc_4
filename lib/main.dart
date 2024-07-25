import 'package:flutter/material.dart';
import 'package:flutter_application_1/logic/blocs/currency_bloc.dart';
import 'package:flutter_application_1/logic/observer/all_observer.dart';
import 'package:flutter_application_1/repositories/currency_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/screens/currency_list_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CurrencyBloc(CurrencyRepository()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Currency Converter',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CurrencyListScreen(),
      ),
    );
  }
}
