import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/screens/currency_conversion_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/currency_bloc.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(FetchCurrencies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          onChanged: (value) {
            context.read<CurrencyBloc>().add(
                  FetchCurrenciesByText(text: value),
                );
          },
        ),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrencyLoaded) {
            return ListView.builder(
              itemCount: state.currencies.length,
              itemBuilder: (context, index) {
                final currency = state.currencies[index];
                return ListTile(
                  title: Text(currency.name),
                  subtitle: Text('Rate: ${currency.rate}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CurrencyConversionScreen(currency: currency),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load currencies'));
          }
        },
      ),
    );
  }
}
