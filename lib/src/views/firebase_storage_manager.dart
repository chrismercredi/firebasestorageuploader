import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FirebaseStorageUploaderRepository(),
        ),
        RepositoryProvider(
          create: (context) => FirebaseStorageBucketRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) =>
                FirebaseStorageManagerBloc(typeGroup: typeGroup),
          ),
          BlocProvider(
            create: (context) => FirebaseBucketManagerBloc(
                repository: FirebaseStorageBucketRepository())
              ..add(const FetchFiles()),
          ),
        ],
        // TODO: Figure out the best way to display the screen's for uploads and buckets.
        // child: const FirebaseStorageManagerScreen(),
        child: const FileGridView(),
      ),
    );
  }
}
