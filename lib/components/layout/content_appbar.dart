import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/screens/auth/account_settings.dart';
import 'package:adventour/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:adventour/globals.dart' as globals;
import 'package:provider/provider.dart';

class ContentAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const ContentAppbar({
    super.key,
    required this.title,
  });

  @override
  State<ContentAppbar> createState() => _ContentAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ContentAppbarState extends State<ContentAppbar> {
  late final UserRepository userRepository;

  @override
  void initState() {
    super.initState();
    userRepository = context.read<UserRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF134546),
      centerTitle: true,
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FutureBuilder<String>(
            future: _fetchImageUrl(), // Busca a imagem de perfil
            builder: (context, snapshot) {
              Widget avatar;

              if (snapshot.connectionState == ConnectionState.waiting) {
                avatar = const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person),
                );
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                avatar = const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.error),
                );
              } else {
                avatar = CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(snapshot.data!),
                );
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettings(),
                    ),
                  );
                },
                child: avatar,
              );
            },
          ),
        ),
      ],
    );
  }


  Future<String> _fetchImageUrl() async {
    var photoUrl = globals.photoUrl;
    if (photoUrl?.isEmpty ?? true) {
      var response = await userRepository.getUserData();
      photoUrl = response?.data?.photoUrl.isEmpty == true
          ? UserUtils().getUserInitial(response?.data)
          : response?.data?.photoUrl;
    }
    return photoUrl!;
  }
}
