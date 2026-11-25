import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- ВОТ ЭТОТ ИМПОРТ БЫЛ ПРОПУЩЕН
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/crates/domain/repositories/crates_repository.dart';
import '../../features/crates/presentation/cubit/list_cubit.dart';
import '../../features/crates/presentation/views/detail_screen.dart';
import '../../features/crates/presentation/views/list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => ListCubit(context.read<CratesRepository>()),
        child: const ListScreen(),
      ),
    ),
    GoRoute(
      path: '/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(id: id);
      },
      routes: [
        GoRoute(
          path: 'related',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailScreen(id: 'Related to $id');
          },
        ),
      ],
    ),
  ],
);
