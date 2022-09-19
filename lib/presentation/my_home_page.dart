import 'package:dio_example/view_models/my_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Get data with dio!"),
        ),
        body:
            Consumer<MyViewModel>(builder: (context, viewModelInstance, child) {
          return viewModelInstance.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: List.generate(
                      viewModelInstance.topLevelData!.data.memes.length,
                      (currentIndex) {
                    var meme = viewModelInstance
                        .topLevelData!.data.memes[currentIndex];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 6,
                              blurRadius: 5,
                              offset: const Offset(1, 3),
                              color: Colors.grey.shade300,
                            ),
                          ]),
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              child: Image.network(meme.url)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [const Text("ID"), Text(meme.id)],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [const Text("Name"), Text(meme.name)],
                          )
                        ],
                      ),
                    );
                  }),
                );
        }));
  }
}
