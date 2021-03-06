import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_coming_soon.dart';
import '../../../domain/usecases/get_playing_now.dart';
import '../../../domain/usecases/get_popular.dart';

part 'movie_tabbed_state.dart';

class MovieTabbedCubit extends Cubit<MovieTabbedState> {
  final GetPopular? getPopular;
  final GetPlayingNow? getPlayingNow;
  final GetComingSoon? getComingSoon;

  MovieTabbedCubit({
    required this.getPopular,
    required this.getPlayingNow,
    required this.getComingSoon,
  }) : super(MovieTabbedInitial());

  void movieTabChanged({int? currentTabIndex = 0}) async {
    emit(MovieTabLoading(currentTabIndex: currentTabIndex));
    Either<AppError, List<MovieEntity>>? moviesEither;
    switch (currentTabIndex) {
      case 0:
        moviesEither = await (getPopular!(NoParams()) as FutureOr<Either<AppError, List<MovieEntity>>?>);
        break;
      case 1:
        moviesEither = await (getPlayingNow!(NoParams()) as FutureOr<Either<AppError, List<MovieEntity>>?>);
        break;
      case 2:
        moviesEither = await (getComingSoon!(NoParams()) as FutureOr<Either<AppError, List<MovieEntity>>?>);
        break;
    }
    emit(moviesEither!.fold(
      (l) => MovieTabLoadError(
        currentTabIndex: currentTabIndex,
        errorType: l.appErrorType,
      ),
      (movies) {
        return MovieTabChanged(
          currentTabIndex: currentTabIndex,
          movies: movies,
        );
      },
    ));
  }
}
