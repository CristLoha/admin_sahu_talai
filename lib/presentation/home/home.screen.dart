import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_underline.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contoh Aho Corasick'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: controller.searchController, // Gunakan controller ini
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () => controller.search(), child: Text('Cari')),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: controller.getStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Obx(() {
                // Jika pengguna belum memulai pencarian (controller.searchResults kosong)
                // atau jika pencarian tidak menghasilkan hasil, tampilkan semua data dari Firebase.
                if (controller.searchResults.isEmpty ||
                    controller.searchResults.last == "Data tidak cocok") {
                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: UnderlineText(
                          text: data['kataSahu'],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  // Jika pengguna telah memulai pencarian dan pencarian menghasilkan hasil, tampilkan hasil pencarian.
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) => ListTile(
                        title: UnderlineText(
                          text: controller.searchResults[index],
                        ),
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
