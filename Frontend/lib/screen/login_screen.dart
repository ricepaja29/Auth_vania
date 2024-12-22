import 'package:frontend/service/auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _fetchedData; // Menyimpan data yang diambil

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await fetchProtectedData(); // Ambil data dari API
      setState(() {
        _fetchedData = data; // Simpan data ke state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil diambil!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengambil data: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleHapusToken() async {
    try {
      await logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : handleLogin,
              child: Text(_isLoading ? "Loading..." : "Login"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : handleFetchData,
              child: const Text("Fetch Data"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleHapusToken,
              child: const Text("Hapus Access Token"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _fetchedData == null
                  ? const Center(child: Text("Tidak ada data untuk ditampilkan"))
                  : ListView.builder(
                      itemCount: _fetchedData!.length,
                      itemBuilder: (context, index) {
                        final key = _fetchedData!.keys.elementAt(index);
                        final value = _fetchedData![key];
                        return ListTile(
                          title: Text("$key: $value"),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
