import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/usecases/update_contacts_usecase.dart';

part 'update_contacts_event.dart';
part 'update_contacts_state.dart';

class UpdateContactsBloc extends Bloc<UpdateContactsEvent, UpdateContactsState> {
  final UpdateContactsUsecase useCase;

  UpdateContactsBloc({required this.useCase}) : super(UpdateContactsInitial()) {
    on<UpdateContact>((event, emit) async {
      emit(UpdateContactsLoading());
      final (failure, _) = await useCase(event.contact);

      if (failure == null) {
        emit(UpdateContactsSuccess());
      } else {
        emit(UpdateContactsError(failure.message.toString()));
      }
    });
  }
}
