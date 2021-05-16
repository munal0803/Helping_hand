
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Helping_hand',
      theme: ThemeData(

        primarySwatch:Colors.indigo,
      ),
      home:Mainpage(),
    );
  }
}

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int col=34;
  // List todos = List();
  List items = List();
  List<String> todos= [];

  String input ="";
  String item=" ";

  createTodos(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(input);

    Map<String,String> todos = {"todoTitle":input};
    documentReference.set(todos).whenComplete((){
      print("$input created");
    });
  }
  // createItems(){
  //   DocumentReference documentReference1 = FirebaseFirestore.instance.collection("Myitems").doc(item);
  //
  //   Map<String,String> items = {"todoTitle":item};
  //   documentReference1.set(items).whenComplete((){
  //     print("$item created");
  //   });
  // }

  deleteTodos(){

  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Helping Hand')),),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder:(BuildContext context){
            return AlertDialog(
            title: Text("Add Item"),

          content: Container(
            height:150,
            child: Column(

              children: [
                TextField(
                onChanged:(String val){
                  input = val;
                },

                ),
                TextField(
                  onChanged:(String val){
                    item =  val;
                    items.add(item);

                    },

                ),
              ],
            ),
          ),
              actions: [
                FlatButton(onPressed: (){
                  if(col<200){
                  col=col+45;
                  }

                  createTodos();

                   Navigator.of(context).pop();

                }, child:  Text("Add"))
              ],

            );
          });
        },
        child: Icon(
          Icons.add,
          color:Colors.white,
        ),

      ),

      body:StreamBuilder(stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
      builder:(context,snapshots){
        if(snapshots.data == null) return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
        itemCount: snapshots.data.docs.length,
        itemBuilder:(context,index){
          DocumentSnapshot documentSnapshot1 = snapshots.data.docs[index];
          DocumentSnapshot documentSnapshot = snapshots.data.docs[index];
    return Dismissible(key: Key(index.toString()), child:Card(
    elevation: 3,
    margin: EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius:
    BorderRadius.circular(4)),
    child:Column(
    children: [
      SizedBox(height: 9,),

    ListTile(title: Text(documentSnapshot["todoTitle"],style: TextStyle(
        color: Colors.black54,
    ),
    ),

    // ),
    // // SizedBox(
    // //   height:2,
    // // ),
    // ListTile(title: Text(items[index],style: TextStyle(
    // color:Colors.black54,
    //              ),),
    trailing: IconButton(
    icon:Icon(
    Icons.delete,
    color: Colors.red,
    ),
    onPressed: (){
    setState(() {
    todos.removeAt(index);
    items.removeAt(index);

    });
    },
    ),
    ),
      // Container(
      //   child:Text(documentSnapshot1["todoTitle"],style: TextStyle(
      //     color:Colors.black54,
      //
      //   ),),
      // ),


    ],
    ),
    )
    );
    });
    },
      )

    );

  }
}
