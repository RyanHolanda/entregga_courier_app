import 'package:entregga_courier/global_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? formatedLoginErrorTitle;
String? formatedLoginErrorDescription;

class FormatError {
  final context = MyGlobalKey.globalKey!.currentContext!;
  setErrorMessage(loginError) {
    switch (loginError) {
      case 'not-found':
        formatedLoginErrorTitle = AppLocalizations.of(context)!.notFound;
        formatedLoginErrorDescription =
            AppLocalizations.of(context)!.unknownStoreOrCourier;
        break;
    }
  }
}
