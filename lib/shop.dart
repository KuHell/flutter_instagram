import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // var result = await firestore.collection('product').doc('gOwjL6OdjulycT4cDPcP').get(); // doc 내용 불러오기
    // var result = await firestore.collection('product').get(); // 전부 불러오기
    // await firestore.collection('product').add({ 'name': '내복', 'price': 1000 }); // 데이터베이스 저장
    // await firestore.collection('product').where(field).get(); // 조건충족되는 데이터만 가져오기
    // await firestore.collection('product').doc('gOwjL6OdjulycT4cDPcP').update({}); // 수정
    // await firestore.collection('product').doc().delete(); // 삭제
    // for (var doc in result.docs) {
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵 페이지 임'),
    );
  }
}
