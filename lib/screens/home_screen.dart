import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/todo_card_widget.dart';
import '../widgets/productions_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();
  bool isMin = false;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset >= 100) {
        setState(() {
          isMin = true;
        });
      } else {
        setState(() {
          isMin = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            flexibleSpace: isMin
                ? FlexibleSpaceBar(
                    background: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ))
                : Container(),
            backgroundColor: isMin ? Colors.transparent : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 29,
              ),
              onPressed: () {
                
              },
            ),
            pinned: true,
            title: const Text(
              'Студенческий туризм',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
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
          const ListTodoCardWidgets(),
          const ListProductionsWidgets(),
        ],
      ),
    );
  }
}
