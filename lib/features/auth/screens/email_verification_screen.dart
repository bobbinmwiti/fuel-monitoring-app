// lib/features/auth/screens/email_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../bloc/auth_bloc.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late Timer _timer;
  int _timeLeft = 60;
  bool _canResendEmail = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _checkEmailVerification();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        setState(() {
          _canResendEmail = true;
        });
        timer.cancel();
      }
    });
  }

  void _checkEmailVerification() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      // TODO: Check if email is verified
      // If verified:
      // timer.cancel();
      // if (mounted) {
      //   Navigator.of(context).pushReplacementNamed('/dashboard');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            context.read<AuthBloc>().add(const SignOutRequested());
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Verify your email',
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to:\n${widget.email}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please check your email and click the verification link',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    if (!_canResendEmail) ...[
                      const Divider(height: 24),
                      Text(
                        'You can resend email in $_timeLeft seconds',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Resend Email',
                onPressed: _canResendEmail
                    ? () {
                        // TODO: Implement resend email
                        setState(() {
                          _canResendEmail = false;
                          _timeLeft = 60;
                        });
                        _startTimer();
                      }
                    : null,
                isOutlined: true,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Use a Different Email',
                onPressed: () {
                  context.read<AuthBloc>().add(const SignOutRequested());
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}