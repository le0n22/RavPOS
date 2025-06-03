import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/management/widgets/user_form.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';
import 'package:ravpos/shared/models/models.dart';

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Yönetimi'),
        centerTitle: true,
      ),
      body: usersAsync.when(
        data: (users) => users.isEmpty
            ? const Center(child: Text('Henüz kullanıcı bulunmamaktadır.'))
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserListItem(context, user, ref);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(context, null, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserListItem(BuildContext context, AppUser user, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 51),
          child: Icon(
            user.role.icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(user.name),
        subtitle: Text(
          '${user.username} - ${user.role.displayName} ${user.isActive ? "" : "(Aktif Değil)"}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showUserForm(context, user, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _confirmDelete(context, user, ref),
            ),
          ],
        ),
        onTap: () => _showUserForm(context, user, ref),
      ),
    );
  }
  
  void _showUserForm(BuildContext context, AppUser? user, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          minChildSize: 0.6,
          initialChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    user == null ? 'Yeni Kullanıcı Ekle' : 'Kullanıcıyı Düzenle',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: UserForm(
                      user: user,
                      onSave: (newUser) {
                        if (user == null) {
                          ref.read(userProvider.notifier).addUser(newUser);
                        } else {
                          ref.read(userProvider.notifier).updateUser(newUser);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _confirmDelete(BuildContext context, AppUser user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kullanıcıyı Sil'),
        content: Text('${user.name} kullanıcısını silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(userProvider.notifier).deleteUser(user.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
} 