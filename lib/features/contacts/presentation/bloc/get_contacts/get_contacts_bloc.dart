import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/usecases/get_contacts_usecase.dart';

part 'get_contacts_event.dart';
part 'get_contacts_state.dart';

class GetContactsBloc extends Bloc<GetContactsEvent, GetContactsState> {
  final GetContactsUsecase useCase;
  GetContactsBloc({required this.useCase}) : super(GetContactsInitial()) {
    on<GetDataContacts>((event, emit) async {
      emit(GetContactsLoading());
      final (failure, result) = await useCase(event.userId);

      if (failure == null) {
        emit(GetContactsSuccess(contacts: result!));
      } else {
        emit(GetContactsError(message: failure.message));
      }
    });
    
  }
  
}
