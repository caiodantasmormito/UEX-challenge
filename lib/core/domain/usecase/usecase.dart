
import 'package:equatable/equatable.dart';
import 'package:uex_app/core/domain/failure/failure.dart';


abstract interface class UseCase<Type, Params> {
  Future<(Failure?, Type?)> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
