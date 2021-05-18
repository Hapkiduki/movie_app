import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/common/constants/languages.dart';
import 'package:movie_app/domain/entities/app_error.dart';
import 'package:movie_app/domain/entities/language_entity.dart';
import 'package:movie_app/domain/entities/no_params.dart';
import 'package:movie_app/domain/usecases/get_preferred_language.dart';
import 'package:movie_app/domain/usecases/update_language.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<Locale> {
  final GetPreferredLanguage? getPreferredLanguage;
  final UpdateLanguage? updateLanguage;

  LanguageCubit({
    required this.getPreferredLanguage,
    required this.updateLanguage,
  }) : super(
          Locale(Languages.languages[0].code),
        );

  void toggleLanguage(LanguageEntity language) async {
    await updateLanguage!(language.code);
    loadPreferredLanguage();
  }

  void loadPreferredLanguage() async {
    final response = await (getPreferredLanguage!(NoParams())
        as Future<Either<AppError, String>>);
    emit(response.fold(
      (l) => Locale(Languages.languages[0].code),
      (r) => Locale(r),
    ));
  }
}
