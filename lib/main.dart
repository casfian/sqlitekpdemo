import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqlitekpdemo/databasehandler.dart';
import 'package:sqlitekpdemo/edit.dart';
import 'package:sqlitekpdemo/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final negaraController = TextEditingController();

  //late maksud = bila kita nak guna, baru dia digunakan
  late DatabaseHandler handler;

  @override
  void initState() {
    //perlu ada handler utk handle database
    this.handler = DatabaseHandler();
    super.initState();
    //Add this if want to populate Data
    //this.handler.initializeDB().whenComplete(() async {
    //await this.addUsers();
    //   setState(() {});
    // });
  }

  //add single user
  Future<int> addUser(String _name, int _age, String _country) async {
    User user = User(name: _name, age: _age, country: _country);
    return await this.handler.insertUser(user);
  }

  //Add multiple users
  Future<int> addUsers() async {
    User firstUser = User(name: "Ali", age: 24, country: "Malaysia");
    User secondUser = User(name: "Abu", age: 31, country: "Malaysia");
    List<User> listOfUsers = [firstUser, secondUser];
    return await this.handler.insertUsers(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SqliteKP demo'),
        actions: [
          IconButton(
              onPressed: () {
                //code saya
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Tambah data'),
                        content: Container(
                          width: 300,
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nama:'),
                              TextField(
                                controller: namaController,
                              ),
                              Text('Umur:'),
                              TextField(
                                controller: umurController,
                              ),
                              Text('Negara:'),
                              TextField(
                                controller: negaraController,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //tambah data
                                this
                                    .handler
                                    .initializeDB()
                                    .whenComplete(() async {
                                  await this.addUser(
                                      namaController.text,
                                      int.parse(umurController.text),
                                      negaraController.text);
                                  setState(() {});
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Tambah')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: this.handler.retrieveUsers(),
          builder: (context, AsyncSnapshot<List<User>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await this.handler.deleteUser(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: ListTile(
                      leading: Text(snapshot.data![index].age.toString()),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].country),
                      trailing: IconButton(
                          onPressed: () {
                            //edit
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Edit(pass: snapshot.data![index])))
                                .then(
                                  (value) {
                                    setState(() {
                                      
                                    });
                                  }
                                );
                          },
                          icon: Icon(Icons.edit)),
                    ),
                  );
                });
          }),
    );
  }
}
