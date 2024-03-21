// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    MaterialApp(
      theme: theme,
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => Text('첫 페이지'),
      //   '/detail': (context) => Text('둘째 페이지'),
      // },
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;
  var homeData = [];

  addGet(result){
    setState(() {
      homeData.add(result);
    });
  }

  getData(url) async {
    var result = await http.get(Uri.parse(url));
    if(result.statusCode == 200) {
      setState(() {
          homeData = jsonDecode(result.body);
      });
    }else {
      return FlutterError('안됩니다.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData('https://codingapple1.github.io/app/data.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        title: Text('Instagram'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Upload())
              );
            },
            iconSize: 30,
          ),
        ],
      ),
      body: [
        Home(homeData: homeData, addGet: addGet),
        Text('샵 페이지')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key, this.homeData, this.addGet}) : super(key: key);
  final homeData;
  final addGet;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore(url) async{
    var result = await http.get(Uri.parse(url));
    widget.addGet(jsonDecode(result.body));
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore('https://codingapple1.github.io/app/more1.json');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.homeData.isNotEmpty) {
      return ListView.builder(itemCount: widget.homeData.length, controller: scroll, itemBuilder: (c, i){
        print(c);
        return Column(
          children: [
            Image.network(widget.homeData[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 ${widget.homeData[i]['likes']}'),
                  Text(widget.homeData[i]['user']),
                  Text(widget.homeData[i]['content']),
                ],
              ),
            )
          ],
        );
      });
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이미지업로드화면'),
            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)
            ),
          ],
        )
    );

  }
}