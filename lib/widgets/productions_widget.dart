import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListProductionsWidgets extends StatelessWidget {
  const ListProductionsWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              "Варианты размещений",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Colors.grey[700]),
            ),
            const SizedBox(
              height: 4,
            ),
            albomCard(
              'assets/images/vsgik.jpg',
              'База отдыха ВСГИК "ОСЛИК"',
              'Байкал  Июнь 14, 2022 - Август 23, 2022',
            ),
            const SizedBox(
              height: 5,
            ),
            albomCard(
              'assets/images/chemal.jpg',
              'База учебных практик "Чемал"',
              'Алтай  Июнь 09, 2022 - Август 30, 2022',
            ),
            coloredCard()
          ]),
        ),
      ),
    );
  }

  Padding coloredCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          cardWidget(
              'assets/images/Users.svg',
              const Color.fromARGB(255, 52, 101, 195),
              const Color.fromARGB(255, 87, 133, 222),
              'Мои сети\n',
              'Подключайтесь и расширяйте свою сеть'),
          cardWidget(
              'assets/images/Vector.svg',
              const Color.fromARGB(255, 236, 78, 39),
              const Color.fromARGB(255, 244, 126, 97),
              'Поиск жилья',
              'Найдите жилье себе быстро и удобно'),
          cardWidget(
              'assets/images/Subtract.svg',
              const Color.fromARGB(255, 107, 52, 195),
              const Color.fromARGB(255, 142, 94, 219),
              'Мой профиль',
              'Обновляйте свой, чтобы быть в топе'),
        ],
      ),
    );
  }

  static GestureDetector albomCard(String imageUrl, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        debugPrint('go to albom');
      },
      child: Card(
        color: const Color.fromARGB(255, 240, 242, 245),
        elevation: 0,
        child: Stack(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 10,
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 101, 101, 101)),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 20,
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Expanded cardWidget(String imageUrl, Color color1, Color color2, String title,
      String subtitle) {
    return Expanded(
      child: SizedBox(
        height: 160,
        child: Card(
          child: InkWell(
            onTap: () {
              debugPrint('go to page');
            },
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                )),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          imageUrl,
                          width: 35,
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(subtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            )),
                      ]),
                )),
          ),
        ),
      ),
    );
  }
}
