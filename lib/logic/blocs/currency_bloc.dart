import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/models/currency.dart';
import 'package:flutter_application_1/repositories/currency_repository.dart';
import 'package:stream_transform/stream_transform.dart';

// Events
abstract class CurrencyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCurrencies extends CurrencyEvent {}

class FetchCurrenciesByText extends CurrencyEvent {
  final String text;

  FetchCurrenciesByText({required this.text});
}

// States
abstract class CurrencyState extends Equatable {
  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;
  CurrencyLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrencyError extends CurrencyState {}

// Bloc
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository repository;
  CurrencyBloc(this.repository) : super(CurrencyInitial()) {
    on<FetchCurrencies>(_onFetchCurrencies);
    on<FetchCurrenciesByText>(
      _onFetchCurrenciesByText,
      transformer: (events, mapper) =>
          events.throttle(const Duration(milliseconds: 300)).switchMap(mapper),
    );
  }

  void _onFetchCurrencies(FetchCurrencies event, emit) async {
    emit(CurrencyLoading());
    try {
      final currencies = await repository.fetchCurrencies();
      emit(CurrencyLoaded(currencies));
    } catch (_) {
      emit(CurrencyError());
    }
  }

  void _onFetchCurrenciesByText(FetchCurrenciesByText event, emit) async {
    emit(CurrencyLoading());
    try {
      final currencies = await repository.fetchCurrencies();
      emit(CurrencyLoaded(
        currencies
            .where((element) =>
                element.name.toLowerCase().contains(event.text.toLowerCase()))
            .toList(),
      ));
    } catch (_) {
      emit(CurrencyError());
    }
  }
}
