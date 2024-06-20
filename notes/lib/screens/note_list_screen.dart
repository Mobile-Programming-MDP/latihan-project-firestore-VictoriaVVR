import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/google_maps_screen.dart';
import 'package:notes/services/note_service.dart';
import 'package:notes/theme_provider.dart';
import 'package:notes/widgets/note_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Provider.of<ThemeProvider>(context).isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return NoteDialog();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: NoteService.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Notes Available'),
              );
            }
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: Column(
                    children: [
                      if (document.imageUrl != null &&
                          Uri.parse(document.imageUrl!).isAbsolute)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            document.imageUrl!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                      ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NoteDialog(note: document);
                            },
                          );
                        },
                        title: Text(document.title),
                        subtitle: Text(document.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoogleMapsScreen(
                                      latitude: double.parse(document.lat!),
                                      longitude: double.parse(document.lng!),
                                    ),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.map),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                await _share(context, document);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.share),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                _showDeleteDialog(context, document);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }

Future<void> _share(BuildContext context, Note document) async {
  try {
    // Show loading indicator dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Prepare the message to share
    String message =
        'Title: ${document.title}\nDescription: ${document.description}\n'
        'Location: https://www.google.com/maps/search/?api=1&query=${document.lat},${document.lng}';

    if (document.imageUrl != null && Uri.parse(document.imageUrl!).isAbsolute) {
      // Fetch image from URL and save it to a temporary file
      final String savedImagePath = await _saveImageToFile(document.imageUrl!);

      // Share the saved image file and text
      await Share.shareXFiles([XFile(savedImagePath)], text: message);
    } else {
      // Share text only
      await Share.share(message);
    }
  } catch (e) {
    print('Error sharing: $e');
    // Handle error gracefully, show an error message to the user if needed
  } finally {
    // Dismiss the loading indicator dialog
    Navigator.of(context, rootNavigator: true).pop();
  }
}

Future<String> _saveImageToFile(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    final documentDirectory = await getTemporaryDirectory();
    final imgFile = File('${documentDirectory.path}/flutter.png');
    await imgFile.writeAsBytes(response.bodyBytes);
    return imgFile.path;
  } else {
    throw Exception('Failed to load image: ${response.statusCode}');
  }
}


  void _showDeleteDialog(BuildContext context, Note document) {
    Widget cancelButton = ElevatedButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () {
        NoteService.deleteNote(document).whenComplete(() {
          Navigator.of(context).pop();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete Note"),
      content: const Text("Are you sure to delete Note?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
