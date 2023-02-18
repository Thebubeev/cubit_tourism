import 'package:flutter/material.dart';
import 'package:test_task/api/api.dart';
import 'package:test_task/constants/constants.dart';
import 'package:test_task/models/place.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Студенческий туризм',
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
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
          const SizedBox(
            width: 10,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Привет, Арсалан!',
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
                                  return albomCard(
                                      snapshot.data![index].imageUrl,
                                      snapshot.data![index].name,
                                      snapshot.data![index].city);
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
