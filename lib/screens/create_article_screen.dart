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
  bool _hasContent = false;

  final ImagePicker _picker = ImagePicker();

  // Color scheme to match home screen
  static const Color primaryBlue = Color(0xFF5B9BD5);
  static const Color lightBlue = Color(0xFF87CEEB);
  static const Color backgroundBlue = Color(0xFFF0F8FF);

  static const Map<String, String> _contentTypes = {
    'bebas': 'Bebas',
    'resensi_buku': 'Resensi Buku',
    'resensi_film': 'Resensi Film',
    'video': 'Video',
  };

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_checkContent);
    _contentController.addListener(_checkContent);
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkContent);
    _contentController.removeListener(_checkContent);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _checkContent() {
    final hasTitle = _titleController.text.trim().length >= 5;
    final hasContentText = _contentController.text.trim().length >= 50;
    final shouldShow = hasTitle && hasContentText;
    
    if (shouldShow != _hasContent) {
      setState(() {
        _hasContent = shouldShow;
      });
    }
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
        backgroundColor: isError ? Colors.red.shade400 : primaryBlue,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Tulis Artikel Baru',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeaderGradient(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormContent(),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryBlue,
            primaryBlue.withOpacity(0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormFields(),
          const Divider(height: 1, color: Colors.transparent),
          _buildContentEditor(),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Detail Artikel', Icons.edit_rounded),
          const SizedBox(height: 20),
          _buildTitleField(),
          const SizedBox(height: 20),
          _buildContentTypeField(),
          const SizedBox(height: 24),
          _buildSectionTitle('Gambar Sampul', Icons.image_rounded),
          const SizedBox(height: 16),
          _buildImagePicker(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
        color: backgroundBlue.withOpacity(0.3),
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: 'Judul Artikel',
          labelStyle: TextStyle(color: primaryBlue.withOpacity(0.8)),
          hintText: 'Tulis judul yang menarik...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.title_rounded, color: primaryBlue, size: 20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '',
        ),
        maxLength: 100,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    );
  }

  Widget _buildContentTypeField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
        color: backgroundBlue.withOpacity(0.3),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedJenis,
        decoration: InputDecoration(
          labelText: 'Jenis Konten',
          labelStyle: TextStyle(color: primaryBlue.withOpacity(0.8)),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.category_rounded, color: primaryBlue, size: 20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        items: _contentTypes.entries
            .map(
              (e) => DropdownMenuItem(
                value: e.key, 
                child: Text(e.value),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _selectedJenis = v ?? 'bebas'),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: primaryBlue.withOpacity(0.2), width: 2),
        borderRadius: BorderRadius.circular(15),
        color: backgroundBlue.withOpacity(0.3),
      ),
      child: _imageFile != null
          ? _buildImagePreview()
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tambah Gambar Sampul',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Maksimal 5MB • JPG, PNG',
                style: TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.w500),
              ),
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
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            _imageFile!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: _removeImage,
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentEditor() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Isi Artikel', Icons.article_rounded),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: primaryBlue.withOpacity(0.2)),
              color: backgroundBlue.withOpacity(0.3),
            ),
            child: TextFormField(
              controller: _contentController,
              maxLines: null,
              minLines: 12,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 16, height: 1.5),
              decoration: InputDecoration(
                labelText: 'Tulis artikel Anda di sini...',
                labelStyle: TextStyle(color: primaryBlue.withOpacity(0.8)),
                hintText: 'Bagikan pemikiran, pengalaman, atau cerita menarik Anda...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.all(20),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (_isLoading || !_hasContent) ? null : _submitArticle,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue, // Selalu biru, bukan kondisional
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          // Opacity untuk disabled state
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return primaryBlue.withOpacity(0.5); // Biru tapi agak transparan
              }
              return primaryBlue; // Biru penuh
            },
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Mengirim...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_rounded, 
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _hasContent ? 'Kirim Artikel' : 'Kirim',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}