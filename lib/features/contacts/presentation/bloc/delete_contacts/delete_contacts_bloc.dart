import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/contacts/domain/usecases/delete_contacts_usecase.dart';

part 'delete_contacts_event.dart';
part 'delete_contacts_state.dart';

class DeleteContactsBloc
    extends Bloc<DeleteContactsEvent, DeleteContactsState> {
  final DeleteContactsUsecase useCase;
  DeleteContactsBloc({required this.useCase}) : super(DeleteContactsInitial()) {
    on<DeleteContact>((event, emit) async {
      emit(DeleteContactsLoading());
      final (failure, _) = await useCase(event.contactId);

      if (failure == null) {
        emit(DeleteContactsSuccess());
      } else {
        emit(DeleteContactsError(message: failure.message));
      }
    });
  }
}
