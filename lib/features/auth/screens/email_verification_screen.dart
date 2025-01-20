// lib/features/auth/screens/email_verification_screen.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
  late Timer _verificationTimer;
  int _timeLeft = 60;
  bool _canResendEmail = false;
  late ScaffoldMessengerState _scaffoldMessenger;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _checkEmailVerification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    _verificationTimer.cancel();
    super.dispose();
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

  Future<void> _resendVerificationEmail() async {
    try {
      final user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        
        if (!mounted) return;
        
        setState(() {
          _canResendEmail = false;
          _timeLeft = 60;
        });
        _startTimer();
        
        _scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Verification email sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _checkEmailVerification() {
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        try {
          final user = auth.currentUser;
          if (user != null) {
            await user.reload();
            
            if (!mounted) return;
            
            if (user.emailVerified) {
              timer.cancel();
              context.read<AuthBloc>().add(const EmailVerifiedEvent());
              Navigator.of(context).pushReplacementNamed('/dashboard');
            }
          }
        } catch (e) {
          if (!mounted) return;
          
          _scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error verifying email: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
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
                onPressed: _canResendEmail ? _resendVerificationEmail : null,
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
}