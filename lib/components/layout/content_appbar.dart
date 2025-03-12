import 'package:adventour/respositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:adventour/globals.dart' as globals;

class ContentAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ContentAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF134546),
      centerTitle: true,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FutureBuilder<String>(
            future: networkImageUrl(), // Fetch the image URL asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person), // Placeholder icon while loading
                );
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const CircleAvatar(
                  radius: 18,
                  child: Icon(
                      Icons.error), // Show error icon if something goes wrong
                );
              } else {
                return CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      NetworkImage(snapshot.data!), // Load the fetched image
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<String> networkImageUrl() async {
    final UserRepository userRepository = UserRepository();

    var photoUrl = globals.photoUrl;
    if (photoUrl?.isEmpty ?? true) {
      var userdata = await userRepository.getUserData();
      photoUrl = userdata?.photoUrl.isEmpty == true
          ? userRepository.getUserInitial(userdata)
          : userdata?.photoUrl;
    }
    return photoUrl!;
  }
}
