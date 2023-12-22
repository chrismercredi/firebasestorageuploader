// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebasestoragemanager/firebasestoragemanager.dart'; // Replace with your actual import
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FileUploadPage extends StatefulWidget {
//   const FileUploadPage({Key? key}) : super(key: key);

//   @override
//   State<FileUploadPage> createState() => _FileUploadPageState();
// }

// class _FileUploadPageState extends State<FileUploadPage> {
//   bool showSuccess = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('File Uploads'),
//       ),
//       body: BlocListener<StorageManagerBloc, StorageManagerState>(
//         listener: (context, state) {
//           if (state is StorageManagerUploadSuccess) {
//             setState(() => showSuccess = true);
//             Future.delayed(const Duration(seconds: 1), () {
//               Navigator.of(context).pop();
//             });
//           } else if (state is StorageManagerUploadTaskError) {
//             // Optionally handle error state
//           }
//         },
//         child: showSuccess ? _buildSuccessWidget() : _buildUploadTasksWidget(),
//       ),
//     );
//   }

//   Widget _buildSuccessWidget() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.check_circle, size: 60.0, color: Colors.green),
//           SizedBox(height: 20),
//           Text('Upload Successful!'),
//         ],
//       ),
//     );
//   }

//   Widget _buildUploadTasksWidget() {
//     return BlocBuilder<StorageManagerBloc, StorageManagerState>(
//       builder: (context, state) {
//         if (state is StorageManagerUploadTasks) {
//           return ListView.builder(
//             itemCount: state.tasks.length,
//             itemBuilder: (context, index) {
//               final taskInfo = state.tasks[index];
//               return UploadFileProgressCard(taskInfo: taskInfo);
//             },
//           );
//         } else {
//           // Placeholder for other states or when no uploads are happening
//           return const Center(child: Text('No active uploads'));
//         }
//       },
//     );
//   }
// }

// class UploadFileProgressCard extends StatelessWidget {
//   const UploadFileProgressCard({
//     super.key,
//     required this.taskInfo,
//   });

//   final UploadTaskInfo taskInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(taskInfo.task.snapshot.ref.name),
//         subtitle: StreamBuilder<TaskSnapshot>(
//           stream: taskInfo.task.snapshotEvents,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Text('Starting upload...');
//             } else if (snapshot.hasData) {
//               final progress = snapshot.data!.bytesTransferred /
//                   snapshot.data!.totalBytes;
//               if (progress == 1.0) {
//                 context.read<StorageManagerBloc>().add(
//                       RemoveUploadTask(
//                         task: taskInfo,
//                       ),
//                     );
//               }
//               return LinearProgressIndicator(value: progress);
//             } else if (snapshot.hasError) {
//               return const Text('Error during upload');
//             }
//             return const Text('Upload complete');
//           },
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.cancel),
//           onPressed: () {
//             taskInfo.task
//                 .cancel(); // Implement cancellation functionality
//           },
//         ),
//       ),
//     );
//   }
// }
