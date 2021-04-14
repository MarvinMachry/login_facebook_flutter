import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:login_facebook/services/auth_service.dart';

class AuthBloc {
  final authService = AuthService();
  final fb = FacebookLogin();

  Stream<FirebaseUser> get currentUser => authService.currentUser;

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email
        ]
    );

    switch(res.status){
      case FacebookLoginStatus.Success:
        print('Funcionando!');

        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;

        //Convert to Auth Credential
        final AuthCredential credential
        = FacebookAuthProvider.getCredential(accessToken: fbToken.token);

        //User Credential to Sign in with Firebase
        final result = await authService.signInWithCredential(credential);

        print('${result.user.displayName} agora esta logado');

        break;
      case FacebookLoginStatus.Cancel:
        print('login cancelado');
        break;
      case FacebookLoginStatus.Error:
        print('Erro');
        break;
    }
  }

  logout(){
    authService.logout();
  }
}