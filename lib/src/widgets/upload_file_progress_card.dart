import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../src.dart';

class UploadFileProgressCard extends StatefulWidget {
  final UploadTaskInfo taskInfo;
  final Animation<double> animation;
  final VoidCallback onRemove;

  const UploadFileProgressCard({
    Key? key,
    required this.taskInfo,
    required this.animation,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<UploadFileProgressCard> createState() => _UploadFileProgressCardState();
}

class _UploadFileProgressCardState extends State<UploadFileProgressCard> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: SizeTransition(
        sizeFactor: widget.animation,
        child: Card(
          child: ListTile(
            title: Text(widget.taskInfo.task.snapshot.ref.name),
            subtitle: StreamBuilder<TaskSnapshot>(
              stream: widget.taskInfo.task.snapshotEvents,
              builder: (context, snapshot) {
                // Update progress and manage state locally
                if (snapshot.hasData) {
                  _progress = snapshot.data!.bytesTransferred /
                      snapshot.data!.totalBytes;
                  if (_progress == 1.0) {
                    // Trigger fade out and removal
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        widget.onRemove();
                      }
                    });
                  }
                }
                return LinearProgressIndicator(value: _progress);
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => widget.taskInfo.task.cancel(),
            ),
          ),
        ),
      ),
    );
  }
}
