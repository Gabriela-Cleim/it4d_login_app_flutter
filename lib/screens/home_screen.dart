import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../widgets/user_drawer.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários Cadastrados')),
      drawer: UserDrawer(token: token),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getUsers(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar usuários. :('));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name'] ?? 'Sem Nome'),
                subtitle: Text(user['email'] ?? 'Sem E-mail'),
              );
            },
          );
        },
      ),
    );
  }
}
