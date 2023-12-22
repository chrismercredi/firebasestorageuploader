part of 'syntax_example_bloc.dart';

sealed class SyntaxExampleState extends Equatable {
  const SyntaxExampleState();
  
  @override
  List<Object> get props => [];
}

final class SyntaxExampleInitial extends SyntaxExampleState {}
