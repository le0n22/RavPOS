import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ravpos/features/users/providers/user_provider.dart';
import 'package:ravpos/shared/models/app_user.dart';
import 'package:ravpos/shared/models/user_role.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _role = 'waiter';
  String? _errorMessage;
  bool _isLoading = false;

  void _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = AppUser(
        id: '', // Let backend generate or ignore
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        passwordHash: '', // Not used for registration
        role: UserRole.values.firstWhere((r) => r.name == _role),
        isActive: true,
        createdAt: DateTime.now(),
      );
      await ref.read(userProvider.notifier).register(
        user,
        _passwordController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final msg = getFriendlyErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white))),
        );
        setState(() {
          _errorMessage = msg;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String getFriendlyErrorMessage(Object e) {
    final msg = e.toString();
    if (msg.contains('Kullanıcı adı zaten mevcut')) {
      return 'Bu kullanıcı adı zaten kayıtlı.';
    }
    if (msg.contains('Kullanıcı bulunamadı') || msg.contains('Şifre hatalı')) {
      return 'Kullanıcı adı veya şifre hatalı.';
    }
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Yönetici')),
                DropdownMenuItem(value: 'cashier', child: Text('Kasiyer')),
                DropdownMenuItem(value: 'waiter', child: Text('Garson')),
              ],
              onChanged: (value) {
                setState(() {
                  _role = value ?? 'waiter';
                });
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
} 