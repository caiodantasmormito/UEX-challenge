import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_usecase.dart';

part 'get_address_event.dart';
part 'get_address_state.dart';

class GetAddressBloc extends Bloc<GetAddressEvent, GetAddressState> {
  final GetAddressUsecase useCase;
  GetAddressBloc({required this.useCase}) : super(GetAddressInitial()) {
    on<Address>((event, emit) async {
      emit(GetAddressLoading());
      final (failure, result) = await useCase(event.cep);

      if (failure == null) {
        emit(GetAddressSuccess(address: result!));
      } else {
        emit(GetAddressError(message: failure.message));
      }
    });
  }
}
