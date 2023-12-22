import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'syntax_example_event.dart';
part 'syntax_example_state.dart';

class SyntaxExampleBloc extends Bloc<SyntaxExampleEvent, SyntaxExampleState> {
  SyntaxExampleBloc() : super(SyntaxExampleInitial()) {
    on<SyntaxExampleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
