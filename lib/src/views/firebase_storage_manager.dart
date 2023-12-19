import 'package:file_selector/file_selector.dart';
import 'package:firebasestoragemanager/src/bloc/firebase_storage_manager_bloc.dart';
import 'package:firebasestoragemanager/src/repositories/files_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views.dart';

class FireBaseStorageManager extends StatelessWidget {
  const FireBaseStorageManager({super.key});

  /// Defines the types of files that can be selected.
  final XTypeGroup typeGroup = const XTypeGroup(
    label: 'Files',
    extensions: <String>[
      // Images
      'jpg', 'jpeg', 'png',
      // Word documents
      'doc', 'docx',
      // Excel spreadsheets
      'xls', 'xlsx',
      // PowerPoint presentations
      'ppt', 'pptx',
      // PDFs
      'pdf',
      // SVGs
      'svg',
      // Text and Rich Text Format
      'txt', 'rtf',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FilesRepository(),
      child: BlocProvider(
        create: (BuildContext context) =>
            FirebaseStorageManagerBloc(typeGroup: typeGroup),
        child: const FirebaseStorageManagerScreen(),
      ),
    );
  }
}
