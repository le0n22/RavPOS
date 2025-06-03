import 'package:flutter/material.dart';
import 'package:ravpos/shared/models/models.dart';
import 'package:uuid/uuid.dart';

class UserForm extends StatefulWidget {
  final AppUser? user;
  final Function(AppUser user) onSave;

  const UserForm({
    Key? key,
    this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  UserRole _selectedRole = UserRole.cashier;
  bool _isActive = true;
  bool _showPassword = false;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _usernameController.text = widget.user!.username;
      _passwordController.text = widget.user!.passwordHash ?? '';
      _selectedRole = widget.user!.role;
      _isActive = widget.user!.isActive;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              widget.user == null ? 'Yeni Kullanıcı Ekle' : 'Kullanıcıyı Düzenle',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen ad soyad girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir kullanıcı adı girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir şifre girin';
                }
                if (value.length < 6 && widget.user == null) {
                  return 'Şifre en az 6 karakter olmalı';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Role dropdown
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Rolü',
                border: OutlineInputBorder(),
              ),
              items: UserRole.values.map((role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Row(
                    children: [
                      Icon(role.icon),
                      const SizedBox(width: 8),
                      Text(role.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Active checkbox
            CheckboxListTile(
              title: const Text('Kullanıcı Aktif'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value ?? true;
                });
              },
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _saveUser,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveUser() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = AppUser(
        id: widget.user?.id ?? const Uuid().v4(),
        name: _nameController.text,
        username: _usernameController.text,
        passwordHash: _passwordController.text,
        role: _selectedRole,
        isActive: _isActive,
        createdAt: widget.user?.createdAt ?? DateTime.now(),
        updatedAt: widget.user != null ? DateTime.now() : null,
      );
      
      widget.onSave(user);
    }
  }
} 