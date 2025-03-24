import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/usecases/add_contacts_usecase.dart';

part 'add_contacts_event.dart';
part 'add_contacts_state.dart';

class AddContactsBloc extends Bloc<AddContactsEvent, AddContactsState> {
  final AddContactsUsecase useCase;
  AddContactsBloc({required this.useCase}) : super(AddContactsInitial()) {
    on<CreateContacts>((event, emit) async {
      emit(AddContactsLoading());

      final (failure, _) = await useCase(event.params);

      if (failure == null) {
        emit(AddContactsSuccess());
      } else {
        emit(AddContactsError(message: failure.message));
      }
    });
  }
}
