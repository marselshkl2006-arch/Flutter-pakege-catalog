import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/crates/data/repositories/mock_crates_repository.dart';
import 'features/crates/domain/repositories/crates_repository.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'l10n/app_localizations.dart';
import 'common/navigation/app_router.dart';

class CratesCatalogApp extends StatelessWidget {
  const CratesCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CratesRepository>(
          create: (context) => MockCratesRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(create: (context) => SettingsCubit()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) {
            return MaterialApp.router(
              title: 'Crates Catalog',
              debugShowCheckedModeBanner: false, // <-- Убрали ленточку
              routerConfig: appRouter,
              locale: settings.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue, brightness: Brightness.light),
              darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue, brightness: Brightness.dark),
              themeMode: settings.themeMode,
            );
          },
        ),
      ),
    );
  }
}
