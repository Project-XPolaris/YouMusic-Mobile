part of 'my_bloc.dart';

abstract class MyState extends Equatable {
  const MyState();
}

class MyInitial extends MyState {
  @override
  List<Object> get props => [];
}
