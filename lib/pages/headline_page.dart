import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeadlinePage extends StatefulWidget{
  @override
  _HeadlinePageState createState() => _HeadlinePageState();
}

class Headline {
  final String title;
  final String imgUrl;
  final String author;
  final String desc;
  final String date;
  final String url;
  final NewsSource newsSource;

  Headline._({
    this.title,
    this.imgUrl,
    this.author,
    this.desc,
    this.date,
    this.url,
    this.newsSource});

  factory Headline.fromJson(Map<String,dynamic> json){

    return new Headline._(
      title: json['title'] == null ? "No Title" : json['title'],
      imgUrl: json['urlToImage'] == null ? "" : json['urlToImage'],
      author: json['author'] == null ? "Unknown" : json['author'],
      desc: json['description'] == null ? "No description is available" : json['description'],
      date: json['publishedAt'] == null ? "00:00:00" : json['publishedAt'],
      url: json['url'] == null ? "" : json['url'],
      newsSource: NewsSource.fromJson(json['source'])
    );

  }

}

class NewsSource {
  final String id;
  final String name;

  NewsSource._({this.id,this.name});

  factory NewsSource.fromJson(Map<String,dynamic> srcJson){

    return new NewsSource._(
      id: srcJson['id'] == null ? "" : srcJson['id'],
      name: srcJson['name'] == null ? "No Source" : srcJson['name']
    );

  }
}

class _HeadlinePageState extends State<HeadlinePage>{

  var respData = Map<String, dynamic>();
  var source = Map<String, String>();
  var headlines = List();
  var isLoading = false;

  @override
  void initState() {
    _fetchHeadlines();
    super.initState();
  }

  _fetchHeadlines() async{

    setState(() {
      isLoading = true;
    });

    final response = await http.get("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1a1f5879432e4443aed35f15442fc8cd");
    if(response.statusCode == 200){
      respData = json.decode(response.body);

      if(respData['status'] == "ok"){
        headlines = (respData['articles'] as List)
            .map((data) => Headline.fromJson(data))
            .toList();
      }

      setState(() {
        isLoading = false;
      });

    }else{
      throw Exception('Failed To Load..');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(
      child: CircularProgressIndicator(),
    ) :
    Container(
      child: PageView.builder(
        itemCount: headlines.length,
        itemBuilder: (BuildContext context, int index){
          return _headlineCard(headlines[index]);
        },
      ),
    );
  }

  _headlineCard(Headline headline){
    return Card(
      margin: EdgeInsets.all(14.0),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50.0),
            child: SizedBox(
              height: 200.0,
              child: FadeInImage(
                placeholder: AssetImage('assets/image_one.jpg'),
                image: NetworkImage(
                  headline.imgUrl,
                ),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
          Positioned.fill(
            top: 250.0,
            child: Container(
              padding: EdgeInsets.only(
                top: 28.0,
                right: 10.0,
                left: 10.0
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87,Colors.red],
                  tileMode: TileMode.repeated,
                )
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 12.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            headline.date,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          headline.desc,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              "~ "+headline.author,
                              style: TextStyle(
                                color: Colors.white
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10.0,
                  )],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          headline.newsSource.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.share),
                          color: Colors.white,
                          onPressed: _openBottomMenu,
                        )
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              top: 200.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                padding: EdgeInsets.all(10.0),
                height: 70.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black87,blurRadius: 5.0)
                    ]
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      headline.title,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }
  _openBottomMenu(){

  }

}