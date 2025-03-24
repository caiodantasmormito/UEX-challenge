class AddContactsException implements Exception {
  const AddContactsException({required this.message});
  final String message;
}

class GetContactsException implements Exception {
  const GetContactsException({required this.message});
  final String message;
}

class DeleteContactsException implements Exception {
  const DeleteContactsException({required this.message});
  final String message;
}