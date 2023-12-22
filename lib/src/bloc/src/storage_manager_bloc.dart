import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../src.dart';

part 'storage_manager_event.dart';
part 'storage_manager_state.dart';

class StorageManagerBloc
    extends Bloc<StorageManagerEvent, StorageManagerState> {
  final StorageManagerRepository storageManagerRepository;
  List<UploadTask> _uploadTasks = [];

  StorageManagerBloc({required this.storageManagerRepository})
      : super(StorageManagerInitial()) {
    on<ClearPickedFiles>(_onClearPickedFiles);
    on<PickFiles>(_onStorageManagerPickFiles);
    on<RemoveFileFromUploadList>(_removeFileFromUploadList);
    on<RemoveUploadTask>(_onRemoveUploadTask);
    on<UploadFromRawData>(_onUploadFromRawData);
  }

  void _onClearPickedFiles(
    ClearPickedFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    emit(StorageManagerInitial());
  }

  void _onStorageManagerPickFiles(
    PickFiles event,
    Emitter<StorageManagerState> emit,
  ) async {
    var files = await storageManagerRepository.pickFiles();
    emit(HasPickedFiles(files: files));
  }

  void _removeFileFromUploadList(
    RemoveFileFromUploadList event,
    Emitter<StorageManagerState> emit,
  ) async {
    final files = state as HasPickedFiles;
    final newFiles =
        files.files.where((file) => file.path != event.file.path).toList();
    emit(newFiles.isEmpty
        ? StorageManagerInitial()
        : HasPickedFiles(files: newFiles));
  }

  void _onRemoveUploadTask(
    RemoveUploadTask event,
    Emitter<StorageManagerState> emit,
  ) {
    _uploadTasks.remove(event.task);
    emit(_uploadTasks.isEmpty
        ? StorageManagerInitial()
        : UploadTasks(uploadTasks: List.from(_uploadTasks)));
  }

  void _onUploadFromRawData(
    UploadFromRawData event,
    Emitter<StorageManagerState> emit,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      _uploadTasks =
          await storageManagerRepository.uploadFiles(event.files, uid);
      emit(UploadTasks(uploadTasks: _uploadTasks));
    } catch (e) {
      emit(const UploadTaskError(message: 'Error uploading file'));
    }
  }
}
