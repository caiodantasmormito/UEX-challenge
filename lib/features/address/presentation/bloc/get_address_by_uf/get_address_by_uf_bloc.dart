import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_by_uf_usecase.dart';

part 'get_address_by_uf_event.dart';
part 'get_address_by_uf_state.dart';

class GetAddressByUfBloc
    extends Bloc<GetAddressByUfEvent, GetAddressByUfState> {
  final GetAddressByUfUsecase useCase;
  GetAddressByUfBloc({required this.useCase}) : super(GetAddressByUfInitial()) {
    on<AddressByUf>((event, emit) async {
      emit(GetAddressByUfLoading());
      final (failure, result) = await useCase(event.params);

      if (failure == null) {
        emit(GetAddressByUfSuccess(addresses: result!));
      } else {
        emit(GetAddressByUfError(message: failure.message));
      }
    });
  }
}
