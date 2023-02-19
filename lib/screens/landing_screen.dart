import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_task/constants/constants.dart';
import 'package:test_task/firebase_auth/firebase_auth.dart';
import 'package:test_task/firebase_core/firebase_core.dart';
import 'package:test_task/models/place.dart';
import 'package:test_task/screens/authentication/wrapper_auth_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final controller = ScrollController();
  String tripController = '';
  final auth = Auth();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String name = '';

  @override
  void initState() {
    init();
    initFCM();
    super.initState();
  }

  initFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  init() async {
    await users
        .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
        .limit(1)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          name = snapshot.docs.single.get('name');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
            )),
        centerTitle: true,
        title: const Text(
          'Студенческий туризм',
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const WrapperAuthScreen())));
            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Привет, $name',
                      style: Constants.defaultTextStyle,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Text(
                      'Давай выберем маршрут путешествия',
                      style: Constants.defaultBigTextStyle,
                    ),
                  ),
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        tripController = val;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Поиск маршрута',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  StreamBuilder<List<Place>>(
                      stream: FirestoreService.getAllPlace(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Some error'),
                          );
                        }
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 500,
                            child: ListView.builder(
                                itemBuilder: ((context, index) {
                                  if (tripController.isEmpty) {
                                    return albomCard(
                                        snapshot.data![index].imageUrl,
                                        snapshot.data![index].name,
                                        snapshot.data![index].city);
                                  }
                                  if (snapshot.data![index].name
                                      .toLowerCase()
                                      .startsWith(
                                          tripController.toLowerCase())) {
                                    return albomCard(
                                        snapshot.data![index].imageUrl,
                                        snapshot.data![index].name,
                                        snapshot.data![index].city);
                                  }
                                  return Container();
                                }),
                                itemCount: snapshot.data?.length),
                          );
                        } else {
                          return Container();
                        }
                      }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget albomCard(String url, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Stack(alignment: Alignment.bottomLeft, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(url),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.map_sharp,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16))
                  ],
                )
              ],
            ),
          ),
        ]),
      ],
    ),
  );
}
