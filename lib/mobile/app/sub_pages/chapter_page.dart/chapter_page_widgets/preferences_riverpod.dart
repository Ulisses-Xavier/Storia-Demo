import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreferencesState {
  final bool isDarkMode;
  final double fontSize;
  final String fontFamily;

  const PreferencesState({
    required this.isDarkMode,
    required this.fontSize,
    required this.fontFamily,
  });
}

class PreferencesRiverpod extends Notifier<PreferencesState> {
  @override
  PreferencesState build() {
    return PreferencesState(
      isDarkMode: false,
      fontSize: 16,
      fontFamily: 'Poppins',
    );
  }

  void set(PreferencesState data) {
    state = data;
  }
}

final preferencesNotifier =
    NotifierProvider<PreferencesRiverpod, PreferencesState>(
      () => PreferencesRiverpod(),
    );
