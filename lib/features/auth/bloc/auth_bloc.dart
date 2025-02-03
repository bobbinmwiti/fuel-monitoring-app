// lib/features/auth/bloc/auth_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth;

  AuthBloc({
    required UserRepository userRepository,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _userRepository = userRepository,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      // Sign in with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Get user data from Firestore
        final userData = await _userRepository.getUserById(userCredential.user!.uid);
        
        if (userData != null) {
          emit(AuthAuthenticated(user: userData));
        } else {
          emit(const AuthError('User data not found'));
        }
      } else {
        emit(const AuthError('Sign in failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_handleFirebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      // Create user with Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Create user model
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: event.name,
          email: event.email,
          role: 'user',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save user data to Firestore
        await _userRepository.createUser(newUser);
        
        // Send email verification
        await userCredential.user!.sendEmailVerification();

        emit(AuthAuthenticated(user: newUser));
      } else {
        emit(const AuthError('Sign up failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_handleFirebaseAuthError(e)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      await _firebaseAuth.signOut();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}