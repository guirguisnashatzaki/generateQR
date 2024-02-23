import 'package:flutter/material.dart';
import 'package:markfayezenter/clientObject.dart';
import 'package:markfayezenter/dbHandler.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  List<MyClient> clientList = [
    MyClient(
      name: "Guirguis",
      email: "guirguisnashat@outlook.com",
      address: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
      bookingDate: "29/2/2024",
      bookingTime: "5:00 PM",
      carNumber: "395BTN",
      phone: "0123456789",
      price: 500.0,
      service: "Spa"
    )
  ];

  Future<List<MyClient>> getClients() async {
    var db = DBHelper();
    var list = await db.getList();
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hotel Generation"),
      ),
      body: FutureBuilder(
        future: getClients(),
        builder: (BuildContext context, AsyncSnapshot<List<MyClient>> snapshot) {
          if(snapshot.hasData){
            return Container(
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(snapshot.data!.length, (index){
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey
                      ),
                      child: Column(
                        children: [
                          Text(snapshot.data![index].name.toString()),
                          Text(snapshot.data![index].service.toString()),
                          Text(snapshot.data![index].price.toString()),
                          Text(snapshot.data![index].email.toString()),
                          Text(snapshot.data![index].bookingDate.toString()),
                          Text(snapshot.data![index].bookingTime.toString()),
                          Text(snapshot.data![index].phone.toString()),
                          Text(snapshot.data![index].carNumber.toString()),
                          Text(snapshot.data![index].address.toString()),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          }else{
            return const Center(
              child: Text("No clients found"),
            );
          }
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, "/add");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
