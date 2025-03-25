

import 'package:uex_app/core/domain/failure/failure.dart';

final class AddContactsFailure extends Failure {
  const AddContactsFailure({super.message});
}

final class GetContactsFailure extends Failure {
  const GetContactsFailure({super.message});
}
final class DeleteContactsFailure extends Failure {
  const DeleteContactsFailure({super.message});
}

final class UpdateContactsFailure extends Failure {
  const UpdateContactsFailure({super.message});
}