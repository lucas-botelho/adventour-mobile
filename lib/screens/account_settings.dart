import 'package:adventour/models/responses/auth/user.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final ApiService apiService = ApiService();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  UserResponse? user;

  @override
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var firebaseUser = firebaseAuthService.getUser();

    if (firebaseUser != null) {
      var response = await apiService.get(
        Authentication.me,
        await firebaseAuthService.getIdToken(),
        headers: {},
        fromJsonT: (json) => UserResponse.fromJson(json),
      );
      setState(() {
        user = response.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Montserrat',
            ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  lineDivider(),
                  photoOption(),
                  lineDivider(),
                  iconOption(
                      () {},
                      "Email",
                      const Icon(Icons.email, color: Colors.white, size: 50),
                      user?.email ?? ''),
                  lineDivider(),
                  iconOption(
                      () {},
                      "Phone Number",
                      const Icon(Icons.phone, color: Colors.white, size: 50),
                      ''),
                ],
              ),
            ),
            screenDivider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fullWidthButtonWithIconAndArrow(
                      icon: const Icon(Icons.notifications,
                          color: Color.fromARGB(255, 255, 186, 59), size: 30),
                      label: "Notifications",
                      description: "Turn notifications on or off",
                      onPressed: () {}),
                  lineDivider(),
                  fullWidthButtonWithIconAndArrow(
                      icon: const Icon(Icons.flag,
                          color: Color.fromARGB(255, 33, 219, 243), size: 30),
                      label: "Language",
                      description: "Change your language",
                      onPressed: () {}),
                  lineDivider(),
                  fullWidthButtonWithIconAndArrow(
                      icon:
                          const Icon(Icons.lock, color: Colors.white, size: 30),
                      label: "Privacy Policy",
                      onPressed: () {}),
                  lineDivider(),
                  logoutOption(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fullWidthButtonWithIconAndArrow({
    required Icon icon,
    required String label,
    String? description,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.transparent,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (description != null)
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget photoOption() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userImage(user),
          const SizedBox(width: 8),
          Text(
            user?.name ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Tienne",
                  color: Color(0XFFBEF6FB)),
            ),
          ),
        ],
      ),
    );
  }

  Widget userImage(UserResponse? user) {
    return user?.photoUrl != null && user!.photoUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              user.photoUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF41969D),
            child: Text(
              user?.name.substring(0, 1).toUpperCase() ?? "?",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          );
  }

  Widget iconOption(Function onclick, String text, Icon icon, String subText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subText.isNotEmpty) // Only add this if value is not empty
                  Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Tienne",
                  color: Color(0XFFBEF6FB)),
            ),
          ),
        ],
      ),
    );
  }

  Widget logoutOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              await firebaseAuthService.logout(context);
            },
            icon: const Icon(Icons.logout, color: Colors.red, size: 30),
            label: const Text(
              "Log out",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              minimumSize: const Size(double.infinity, 50),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ),
    );
  }

  Container lineDivider() {
    return Container(
      height: 1,
      color: const Color(0xFF41969D),
    );
  }

  Widget screenDivider() {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: const Color(0x77FFFFFF),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Preferences",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
    );
  }
}
