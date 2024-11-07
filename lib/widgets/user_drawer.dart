import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../service/api_service.dart';

class UserDrawer extends StatelessWidget {
  final String token;
  const UserDrawer({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getUserInfo(token),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            print("Erro: ${snapshot.error}");
            return const Center(child: Text('Erro ao carregar dados do usuário.'));
          }

          final user = snapshot.data!;

          String name = user['name'] ?? 'Nome não disponível';
          String avatarUrl = user['avatar'] ?? '';

          String defaultAvatar = 'assets/images/default_avatar.png';

          return ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.indigoAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: avatarUrl.isEmpty
                          ? AssetImage(defaultAvatar)
                          : NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await ApiService.logout(token);

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },

              ),
            ],
          );
        },
      ),
    );
  }
}
