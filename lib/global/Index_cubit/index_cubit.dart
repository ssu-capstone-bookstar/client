import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(IndexState.initial());

  void setIndex({required int index}) {
    emit(state.copyWith(index: index));
  }
}
