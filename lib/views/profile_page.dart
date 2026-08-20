import 'package:aullet/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameCtrl = TextEditingController();
  bool _didScheduleLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didScheduleLoad) {
      _didScheduleLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final vm = context.read<ProfileViewmodel>();
        await vm.loadProfile();
        if (mounted && vm.profile != null) {
          _nameCtrl.text = vm.profile!.displayName;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Profilo'))),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar con Stack e icona di edit dentro il GestureDetector
                  GestureDetector(
                    onTap: vm.pickAndUploadAvatar,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: vm.profile?.avatarUrl != null
                              ? NetworkImage(vm.profile!.avatarUrl!)
                              : null,
                          child: vm.profile?.avatarUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: vm.pickAndUploadAvatar,
                    child: const Text('Cambia Avatar'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => vm.updateDisplayName(_nameCtrl.text),
                    child: const Text('Salva'),
                  ),
                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
