import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hng_mobile/services/shared_prefs.dart';

part 'switch_event.dart';
part 'switch_state.dart';

class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  final ThemePref themePreferences = ThemePref();

  SwitchBloc() : super(const SwitchInitial(switchValue: true)) {
    on<SwitchOnEvent>((event, emit) async {
      await themePreferences.saveTheme(true);
      emit(
        const SwitchState(switchValue: true),
      );
    });

    on<SwitchOffEvent>((event, emit) async {
      await themePreferences.saveTheme(false);
      emit(
        const SwitchState(switchValue: false),
      );
    });

    on<SwitchToggleEvent>((event, emit) async {
      final newValue = !state.switchValue;
      await themePreferences.saveTheme(newValue);
      emit(SwitchState(switchValue: newValue));
    });
  }

  Future<void> loadTheme() async {
    final isLightTheme = await themePreferences.loadTheme();
    emit(SwitchState(switchValue: isLightTheme));
  }
}
