/*import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  // Home Injection
  sl.registerSingleton<RemoteGameDataSource>(RemoteGameDataSource(sl()));
  sl.registerSingleton<GameRepository>(GameRepositoryImpl(sl()));
  sl.registerSingleton<SearchGamesUseCase>(SearchGamesUseCase(sl()));
  sl.registerSingleton<TopReviewsUseCase>(TopReviewsUseCase(sl()));
  sl.registerSingleton<GetGamesUseCase>(GetGamesUseCase(sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl(), sl(), sl()));



  // Details Injection
  sl.registerSingleton<RemoteCommentDataSource>(RemoteCommentDataSource(sl()));
  sl.registerSingleton<CommentRepository>(CommentRepositoryImpl(sl()));
  sl.registerSingleton<LoadCommentsUseCase>(LoadCommentsUseCase(sl()));
  sl.registerSingleton<AddCommentUseCase>(AddCommentUseCase(sl()));
  sl.registerFactory<DetailsBloc>(() => DetailsBloc(sl(), sl()));

  //Profile Injection
  sl.registerSingleton<RemoteUserCommentsDataSource>(RemoteUserCommentsDataSource(sl()));
  sl.registerSingleton<UserCommentsRepository>(UserCommentsRepositoryImpl(sl()));
  sl.registerSingleton<GetUserCommentsUseCase>(GetUserCommentsUseCase(sl()));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl()));
}
*/