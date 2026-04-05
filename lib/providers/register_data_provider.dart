import 'package:flutter_riverpod/flutter_riverpod.dart';

//USADO NO LOGIN DO WEB_DASHBOARD PRA PASSAR OS DADOS DE USUÁRIO NA ABA DE CRIAÇÃO

class RegisterDataProvider extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setData(Map<String, dynamic> newData) {
    state = newData;
  }

  void delete() {
    state = {};
  }
}

final registerDataNotifier =
    NotifierProvider<RegisterDataProvider, Map<String, dynamic>>(
      () => RegisterDataProvider(),
    );
