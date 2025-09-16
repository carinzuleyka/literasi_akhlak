import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:literasi_akhlak/models/auth_model.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _selectedJenis = 'bebas';
  String? _selectedKategori;
  File? _imageFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  static const Map<String, String> _contentTypes = {
    'bebas': 'Bebas',
    'resensi_buku': 'Resensi Buku',
    'resensi_film': 'Resensi Film',
    'video': 'Video',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          _showSnackBar('Ukuran gambar terlalu besar. Maksimal 5MB.',
              isError: true);
          return;
        }
        setState(() => _imageFile = file);
      }
    } catch (e) {
      _showSnackBar('Gagal memilih gambar: $e', isError: true);
    }
  }

  void _removeImage() {
    setState(() => _imageFile = null);
  }

  bool _validateContent() {
    if (_contentController.text.trim().isEmpty) {
      _showSnackBar('Isi artikel tidak boleh kosong.', isError: true);
      return false;
    }
    if (_contentController.text.trim().length < 50) {
      _showSnackBar('Artikel terlalu pendek. Minimal 50 karakter.',
          isError: true);
      return false;
    }
    return true;
  }

  Future<void> _submitArticle() async {
    if (!_formKey.currentState!.validate() || !_validateContent()) return;

    setState(() => _isLoading = true);
    try {
      final response = await AuthService.createArticle(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        jenis: _selectedJenis,
        idKategori: _selectedKategori,
        imageFile: _imageFile,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        _showSnackBar(response['message'] ?? 'Artikel berhasil diunggah!',
            isError: false);
        Navigator.of(context).pop(true);
      } else {
        _showSnackBar(response['message'] ?? 'Gagal mengunggah artikel.',
            isError: true);
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulis Artikel Baru'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: _submitArticle,
                    tooltip: 'Kirim Artikel',
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildFormFields(),
            const Divider(height: 1, thickness: 1),
            Expanded(child: _buildContentEditor()),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Judul Artikel',
              hintText: 'Tulis judul yang menarik...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title_rounded),
              counterText: '',
            ),
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Judul tidak boleh kosong';
              }
              if (value.trim().length < 5) {
                return 'Judul terlalu pendek (minimal 5 karakter)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedJenis,
            decoration: const InputDecoration(
              labelText: 'Jenis Konten',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category_rounded),
            ),
            items: _contentTypes.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedJenis = v ?? 'bebas'),
          ),
          const SizedBox(height: 16),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _imageFile != null
          ? _buildImagePreview()
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              'Tambah Gambar Sampul',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Maksimal 5MB • JPG, PNG',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _imageFile!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: _removeImage,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentEditor() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _contentController,
        maxLines: null,
        minLines: 10,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          labelText: 'Isi Artikel',
          hintText: 'Tulis isi artikel di sini...',
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Isi artikel tidak boleh kosong';
          }
          if (value.trim().length < 50) {
            return 'Artikel terlalu pendek (minimal 50 karakter)';
          }
          return null;
        },
      ),
    );
  }
}
