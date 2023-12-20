import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src.dart';

class FileGridView extends StatelessWidget {
  const FileGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirebaseBucketManagerBloc(
          repository: FirebaseStorageBucketRepository())
        ..add(const FetchFiles()),
      child: BlocBuilder<FirebaseBucketManagerBloc, FirebaseBucketManagerState>(
        builder: (context, state) {
          if (state is FirebaseBucketManagerLoading) {
            return const CircularProgressIndicator();
          } else if (state is FirebaseBucketManagerLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust based on your UI needs
              ),
              itemCount: state.files.length,
              itemBuilder: (context, index) {
                var file = state.files[index];
                return Card(
                  child: Column(
                    children: <Widget>[
                      Text(file.name!),
                      Text('Size: ${file.size}'),
                      Text('Type: ${file.contentType}'),
                      // Display other file details here
                    ],
                  ),
                );
              },
            );
          } else if (state is FirebaseBucketManagerError) {
            return Text('Error: ${state.message}');
          }
          return Container(); // Return an empty container for initial or unknown states
        },
      ),
    );
  }
}
