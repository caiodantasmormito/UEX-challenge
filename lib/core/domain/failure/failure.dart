import 'package:equatable/equatable.dart';

abstract base class Failure extends Equatable {
  const Failure({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}
