import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'syntax_example_state.dart';

class SyntaxExampleCubit extends Cubit<SyntaxExampleState> {
  SyntaxExampleCubit() : super(SyntaxExampleInitial());
}
