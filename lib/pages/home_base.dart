import 'package:flutter/material.dart';
import 'package:testnewtron/pages/bagikan.dart';
import 'package:testnewtron/pages/home.dart';
import 'package:testnewtron/pages/layanan.dart';
import 'package:testnewtron/pages/materi.dart';
import 'package:testnewtron/pages/subscriber.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeBasePage extends StatefulWidget {
  const HomeBasePage({super.key});

  @override
  State<HomeBasePage> createState() => _HomeBasePageState();
}

class _HomeBasePageState extends State<HomeBasePage> {
  String? videoId;
  List<String> items = [
    "Home",
    "Materi",
    "Layanan",
    "Subscriber",
    "Bagikan",
  ];
  List<Widget> pages = [
    const HomePage(),
    const MateriPage(),
    const LayananPage(),
    const SubscriberPage(),
    const BagikanPage(),
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Test Newtron'),
        ),
      ),
      body: Column(
        children: [
          // videoId! != null
          //     ? VideoScreen(id: videoId!)
          //     :
          Container(
            height: 200.0,
            color: Colors.black,
          ),
          Column(
            children: [
              Container(
                color: Color.fromARGB(255, 235, 231, 231),
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: items.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              width: 80,
                              height: 45,
                              decoration: BoxDecoration(
                                color: current == index
                                    ? Colors.white
                                    : Colors.white70,
                                borderRadius: current == index
                                    ? BorderRadius.circular(15)
                                    : BorderRadius.circular(10),
                                border: current == index
                                    ? Border.all(
                                        color: Colors.deepPurpleAccent,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  items[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 561.0,
                width: double.infinity,
                child: pages[current],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
