import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileRepositoryScreen extends StatefulWidget {
  final String categoryName;

  FileRepositoryScreen(this.categoryName);

  @override
  _FileRepositoryScreenState createState() => _FileRepositoryScreenState();
}

class _FileRepositoryScreenState extends State<FileRepositoryScreen> {
  List<String> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositorio de Archivos - ${widget.categoryName}'),
      ),
      body: Column(
        children: [
          if (files.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(files[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          files.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          if (files.isEmpty)
            Center(
              child: Text('No se encuentran archivos asociados.'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        tooltip: 'Subir Archivo',
        child: Icon(Icons.upload_file),
      ),
    );
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        files.add(result.files.single.name);
      });
    }
  }
}
