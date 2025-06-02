import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch (event) {
        case AuthLogin(:var email, :var password):
          emit(AuthInProgress());

          try {
            final credential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);

            final user = credential.user;

            if (user == null) {
              throw Exception("No user found");
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              emit(AuthFailure('No user found for that email.'));
            } else if (e.code == 'wrong-password') {
              emit(AuthFailure('Wrong password provided for that user.'));
            } else {
              emit(AuthFailure(e.code));
            }
          } catch (e) {
            emit(AuthFailure(e.toString()));
          }

        case AuthRegister(:var email, :var password, :var name):
          emit(AuthInProgress());

          try {
            final credential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

            final user = credential.user;

            if (user == null) {
              throw Exception("No user found");
            }

            await FirebaseFirestore.instance
                .collection("person")
                .doc(user.uid)
                .set({"id": user.uid, "email": email, "name": name});
                
            emit(AuthSuccess(user.uid));
          } on FirebaseAuthException catch (e) {
            print(e);
            if (e.code == 'weak-password') {
              emit(AuthFailure('The password provided is too weak.'));
            } else if (e.code == 'email-already-in-use') {
              emit(AuthFailure('The account already exists for that email.'));
            } else {
              emit(AuthFailure(e.code));
            }
          } catch (e) {
            print(e);
            emit(AuthFailure(e.toString()));
          }

        case AuthLogout():
          await FirebaseAuth.instance.signOut();
        case AuthSubscribe():
          await emit.forEach(
            FirebaseAuth.instance.authStateChanges(),
            onData: (user) {
              if (user != null) {
                return AuthSuccess(user.uid);
              } else {
                return AuthNotAuth();
              }
            },
          );
      }
    });
  }

  login({required String email, required String password}) {
    add(AuthLogin(email: email, password: password));
  }

  register({
    required String name,
    required String password,
    required String email,
  }) {
    add(AuthRegister(password: password, name: name, email: email));
  }

  logout() {
    add(AuthLogout());
  }
}
