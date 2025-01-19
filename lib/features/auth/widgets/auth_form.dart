// lib/features/auth/widgets/auth_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';

enum AuthFormType { signIn, signUp }

class AuthForm extends StatefulWidget {
  final AuthFormType type;

  const AuthForm({
    super.key,
    required this.type,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.type == AuthFormType.signIn) {
        context.read<AuthBloc>().add(
          SignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          SignUpRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.type == AuthFormType.signUp) ...[
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: Validators.validateName,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.validateEmail,
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              validator: Validators.validatePassword,
              style: AppTextStyles.bodyLarge,
              onFieldSubmitted: (_) => _submitForm(),
            ),
            const SizedBox(height: 24),

            // Submit Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return CustomButton(
                  text: widget.type == AuthFormType.signIn
                      ? 'Sign In'
                      : 'Sign Up',
                  onPressed: _submitForm,
                  isLoading: isLoading,
                );
              },
            ),
            const SizedBox(height: 16),

            // Switch Auth Mode Button
            CustomButton(
              text: widget.type == AuthFormType.signIn
                  ? 'Create an Account'
                  : 'Already have an account?',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  widget.type == AuthFormType.signIn ? '/signup' : '/login',
                );
              },
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}