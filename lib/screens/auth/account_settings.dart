import 'package:adventour/components/navigation/navbar.dart';
import 'package:adventour/models/responses/auth/user.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/legal/privacy_policy_page.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  late final FirebaseAuthService authService;
  late final UserRepository userRepository;
  UserResponse? user;

  @override
  void initState() {
    super.initState();
    userRepository = context.read<UserRepository>();
    authService = context.read<FirebaseAuthService>();
    _loadUserData();
  }

  void _loadUserData() async {
    final response = await userRepository.getUserData();

    if (response != null) {
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
        bottomNavigationBar: const NavBar(selectedIndex: 4),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitle(),
                              lineDivider(),
                              iconOption(() {}, user?.name ?? '', userImage(user), ''),
                              lineDivider(),
                              iconOption(
                                  _showChangeEmailModal,
                                  "Email",
                                  const Icon(Icons.email,
                                      color: Colors.white, size: 50),
                                  user?.email ?? ''),
                              lineDivider(),
                              iconOption(
                                      () {},
                                  "Phone Number",
                                  const Icon(Icons.phone,
                                      color: Colors.white, size: 50),
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
                              buildArrowButtons(
                                  icon: const Icon(Icons.notifications,
                                      color: Color.fromARGB(255, 255, 186, 59),
                                      size: 30),
                                  label: "Notifications",
                                  description: "Turn notifications on or off",
                                  onPressed: () {}),
                              lineDivider(),
                              buildArrowButtons(
                                  icon: const Icon(Icons.flag,
                                      color: Color.fromARGB(255, 33, 219, 243),
                                      size: 30),
                                  label: "Language",
                                  description: "Change your language",
                                  onPressed: () {}),
                              lineDivider(),
                              buildArrowButtons(
                                icon: const Icon(Icons.lock,
                                    color: Colors.white, size: 30),
                                label: "Privacy Policy",
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const PrivacyPolicyPage()),
                                  );
                                },
                              ),
                              lineDivider(),
                              logoutOption(),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      ),
    );
  }

  Text _buildTitle() {
    return const Text(
      "Account",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildButtonsStyle({
    required Widget icon,
    required String label,
    String? subText,
    VoidCallback? onPressed,
    Widget? trailingWidget,
  }) {
    const String fontFamily = 'Montserrat';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon, // Now accepts any widget, including userImage
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
                    fontFamily: fontFamily,
                  ),
                ),
                if (subText != null && subText.isNotEmpty)
                  Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: fontFamily,
                    ),
                  ),
              ],
            ),
          ),
          if (trailingWidget != null) trailingWidget,
        ],
      ),
    );
  }

  Widget logoutOption() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async {
          await authService.logout(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: buildButtonsStyle(
          icon: const Icon(Icons.logout, color: Colors.red, size: 30),
          label: "Log out",
        ),
      ),
    );
  }

  Widget buildArrowButtons({
    required Icon icon,
    required String label,
    String? description,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: buildButtonsStyle(
          icon: icon,
          label: label,
          subText: description,
          trailingWidget: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget iconOption(
      VoidCallback onClick, String text, Widget icon, String subText) {
    return buildButtonsStyle(
      icon: icon,
      label: text,
      subText: subText,
      trailingWidget: TextButton(
        onPressed: onClick,
        child: editTextButton(),
      ),
    );
  }

  Text editTextButton() {
    return const Text(
      "Edit",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: "Tienne",
        color: Color(0XFFBEF6FB),
      ),
    );
  }

  Widget userImage(UserResponse? user) {
    if (user?.photoUrl != null && user!.photoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          user.photoUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: const Color(0xFF41969D),
      child: Text(
        UserUtils().getUserInitial(user),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
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

  void _showChangeEmailModal() {
    final TextEditingController emailController =
        TextEditingController(text: user?.email ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Email'),
          content: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'New Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newEmail = emailController.text.trim();
                if (newEmail.isNotEmpty && newEmail != user?.email) {
                  // await authService.updateEmail(newEmail);

                  // Optional: refresh local user info
                  _loadUserData();

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
