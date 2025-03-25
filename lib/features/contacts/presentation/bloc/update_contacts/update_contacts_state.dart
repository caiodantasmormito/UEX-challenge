part of 'update_contacts_bloc.dart';
sealed class UpdateContactsState extends Equatable {
  const UpdateContactsState();
}

class UpdateContactsInitial extends UpdateContactsState {
  @override
  List<Object> get props => [];
}

final class UpdateContactsLoading extends UpdateContactsState {
  @override
  List<Object> get props => [];
}

final class UpdateContactsSuccess extends UpdateContactsState {
  @override
  List<Object> get props => [];
}

final class UpdateContactsError extends UpdateContactsState {
  final String message;
  
  const UpdateContactsError(this.message);

  @override
  List<Object> get props => [message];
}