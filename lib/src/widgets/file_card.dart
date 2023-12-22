import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class FileCard extends StatelessWidget {
  final XFile file;
  final VoidCallback onDelete;

  const FileCard({Key? key, required this.file, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Replace the Dismissible with a regular Card
    return Card(
      margin: theme.fileCardMargin,
      child: _cardContent(context, file),
    );
  }

  Widget _cardContent(BuildContext context, XFile file) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Icon(FileUtil.getIconForFileType(file)),
      title: Text(
        StringUtil.truncate(file.name, 30),
        overflow: TextOverflow.ellipsis,
        style: theme.fileCardTitleStyle,
      ),
      subtitle: FutureBuilder<int>(
        future: file.length(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  Text(
                    snapshot.data!.fileSize(context),
                    style: theme.fileCardSubtitleStyle,
                  ),
                ],
              );
            } else {
              return Text('Size not available',
                  style: theme.fileCardSubtitleStyle);
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          onDelete();
        },
      ),
    );
  }
}
