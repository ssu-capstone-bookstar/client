import 'package:bookstar_app/global/state/collection_cubit/collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCollectionPage extends StatelessWidget {
  static const String routeName = 'mycollection';
  static const String routePath = '/mycollection';

  const MyCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('컬렉션'),
      ),
      body: BlocBuilder<CollectionCubit, CollectionState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '아직 컬렉션이 없습니다!',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Add your button action here
                    print('Add button pressed');
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
