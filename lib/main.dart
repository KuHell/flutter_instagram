// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/notification.dart';
import 'package:instagram/shop.dart';
import 'style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Store()),
        // ChangeNotifierProvider(create: (context) => Store1()),
      ],
      child: MaterialApp(
        theme: theme,
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => Text('첫 페이지'),
        //   '/detail': (context) => Text('둘째 페이지'),
        // },
        home: MyApp()
      ),
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
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'John');
  }

  addMyData() {
    var myData = {
      'id': homeData.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      homeData.insert(0, myData);
    });
  }

  setUserContent(content) {
    setState(() {
      userContent = content;
    });
  }

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
    initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        showNotification();
        print('눌렀음');
      }, child: Text('+'),),
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
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if(image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Upload(userImage: userImage, setUserContent: setUserContent, addMyData: addMyData))
              );
            },
            iconSize: 30,
          ),
        ],
      ),
      body: [
        Home(homeData: homeData, addGet: addGet),
        Shop()
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
        print('맨 밑임');
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
            widget.homeData[i]['image'].runtimeType == String
              ? Image.network(widget.homeData[i]['image'])
              : Image.file(widget.homeData[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 ${widget.homeData[i]['likes']}'),
                  GestureDetector(
                    child: Text(widget.homeData[i]['user']),
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(pageBuilder: 
                        (context, a1, a2) => Profile(),
                        transitionsBuilder: (context, a1 , a2, child) => FadeTransition(opacity: a1, child: child,)
                      ));
                    },
                  ),
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
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              addMyData();
              Navigator.pop(context);
            }, icon: Icon(Icons.send))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이미지업로드화면'),
            TextField(onChanged: (text) {
              setUserContent(text);
            },),
            Image.file(userImage),
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

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    context.read<Store>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Profile1()
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // print('zzzzzz ${context.watch<Store>().profileImage}');
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/main.PNG'),
          ),
          Text('팔로우 ${context.watch<Store>().friender}명'),
          ElevatedButton(
              onPressed: (){
                context.read<Store>().addCount();
              },
              child: Text('팔로우')
          )
        ],
      ),
    );
  }
}

class Profile1 extends StatelessWidget {
  const Profile1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store>().name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (c, i) => Container(
                  child: Image.network(context.watch<Store>().profileImage[i]),
                ),
                childCount: context.watch<Store>().profileImage.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3)
          ),
        ],
      )
    );
  }
}



class Store extends ChangeNotifier {
  var friend = false;
  var friender = 0;
  var profileImage = [];
  
  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    profileImage = jsonDecode(result.body);
    notifyListeners();
  }
  
  addCount() {
    if(!friend) {
      friender++;
      friend = true;
    }else {
      friender--;
      friend = false;
    }
    notifyListeners();
  }
  
  var name = 'john kim';
}
