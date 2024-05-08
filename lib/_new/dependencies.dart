import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'dependencies.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<GetIt> configureDependencies() async => await getIt.init();
