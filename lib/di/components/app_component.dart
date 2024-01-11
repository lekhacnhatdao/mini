import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:openvpn/di/components/app_component.config.dart';
import 'package:openvpn/presentations/shareperf/sharedpreferences.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
   await getIt.init();
   await  Preferncent.init();
}
