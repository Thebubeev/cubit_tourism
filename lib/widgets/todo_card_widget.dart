import 'package:flutter/material.dart';

class ListTodoCardWidgets extends StatelessWidget {
  const ListTodoCardWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 8, right: 10),
          child: SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                TodoCardWidget(
                    isProgressBar: true,
                    title: 'Заполните свой профиль для эффективного поиска.',
                    subtitle: 'Заполнить профиль'),
                TodoCardWidget(
                    isProgressBar: false,
                    title: 'Общайтесь с людьми и расширяйте свою сеть.',
                    subtitle: 'Присоединиться'),
                TodoCardWidget(
                    isProgressBar: false,
                    title: 'Пройдите верификацию себя как студента.',
                    subtitle: 'Пройти верификацию')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isProgressBar;
  const TodoCardWidget({
    Key? key,
    required this.isProgressBar,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: 290,
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(255, 240, 242, 245),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 12),
                child: isProgressBar
                    ? const SizedBox(
                        width: 290,
                        height: 14,
                        child: LinearProgressIndicator(
                          minHeight: 2.0,
                          value: 0.7,
                          color: Color.fromARGB(255, 135, 198, 245),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 125, 203, 248)),
                          backgroundColor: Colors.white,
                        ),
                      )
                    : const Opacity(
                        opacity: 0.0,
                        child: SizedBox(
                          width: 290,
                          height: 14,
                          child: LinearProgressIndicator(
                            minHeight: 2.0,
                            value: 0.7,
                            color: Colors.blue,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 125, 203, 248)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
              ),
              InkWell(
                onTap: () {
                  debugPrint('todo something');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_outlined,
                    )
                  ],
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
