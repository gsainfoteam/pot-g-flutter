import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_button.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return PotButton(
            variant: PotButtonVariant.emphasized,
            child: Text(switch (state) {
              Authenticated(:final user) => user.name,
              AuthLoading() => 'Loading...',
              AuthInitial() => 'Initial',
              Unauthenticated() => 'Login',
              AuthError(:final message) => message,
            }),
            onPressed:
                () => context.read<AuthBloc>().add(const AuthEvent.login()),
          );
        },
      ),
    );
  }
}
