import 'dart:ffi';
import 'dart:typed_data';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:markfayezenter/clientObject.dart';
import 'package:markfayezenter/dbHandler.dart';
import 'package:markfayezenter/encryption.dart';
import 'package:markfayezenter/firebase_helper/authentication_provider.dart';
import 'package:markfayezenter/firebase_helper/fireSore_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'custom_text_form_field.dart';
import 'home.dart';

void main() {
  runApp(MyApp(appRouter: AppRouter(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.appRouter});

  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScreenshotController screenshotController =ScreenshotController();
  final GlobalKey genKey = GlobalKey();
  String res = "";

  saveToGallery() async {
    await screenshotController.capture().then((Uint8List? image) async {
      await saveScreenShot(image);
    });
  }

  saveScreenShot(Uint8List? image) async {
    final dateTime = DateTime.now().toIso8601String().replaceAll(".", "-").replaceAll(":", "-");
    final name = "ScreenShot$dateTime";
    await ImageGallerySaver.saveImage(image!,name: name);

    MyAuthentication myAuthentication = MyAuthentication();
    myAuthentication.signIn(emailController.text.toString(), nameController.text.toString()+emailController.text.toString());
    MyFireStore myFireStore = MyFireStore();
    myFireStore.addUser(MyClient(
      name: nameController.text.toString(),
      email: emailController.text.toString(),
      address: addressController.text.toString(),
      bookingDate: date,
      bookingTime: _time.toString(),
      carNumber: carNumberController.text.toString(),
      phone: phoneController.text.toString(),
      price: double.parse(priceController.text.toString()),
      service: activity,
    ));
    Navigator.popAndPushNamed(context, "/");
  }
  List<String> activities = ["Spa", "Sauna", "Day use"];
  bool activityBool = false;
  bool dateBool = false;
  String activity = "Select Service";
  String date = "Select date";
  String time = "Select time";

  Time _time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Client Reservation"),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                customTextFormField(icon: const Icon(Icons.person),text: "Name",isPass: false,controller: nameController,),
                customTextFormField(icon: const Icon(Icons.mail),text: "Email",isPass: false,controller: emailController,),
                customTextFormField(icon: const Icon(Icons.car_rental),text: "Car Number",isPass: false,controller: carNumberController,),
                customTextFormField(icon: const Icon(Icons.phone),text: "Phone",isPass: true,controller: phoneController,),
                customTextFormField(icon: const Icon(Icons.monetization_on_sharp),text: "Price",isPass: true,controller: priceController,),

                Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.home),
                      label: const Text("Address"),
                      labelStyle: const TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    controller: addressController,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        activityBool = !activityBool;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.black, width: 1),
                      ),
                      // alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [

                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                activity,
                                style: const TextStyle(
                                    color: Color.fromRGBO(7, 45, 68, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Tajawal'),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              // setState(() {
                              //   activityBool = !activityBool;
                              // });
                            },
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), //activity
                activityBool
                    ? Container(
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 6)
                      ]),
                  child: Column(
                    children: List.generate(
                        activities.length,
                            (index) => InkWell(
                          onTap: () {
                            setState(() {
                              activityBool = false;
                              activity = activities[index];
                            });
                          },
                          child: ListItem(
                            text: activities[index],
                            ifFirst: index == 0 ? true : false,
                            ifLast:
                            index == activities.length - 1 ? true : false,
                          ),
                        )),
                  ),
                )
                    : const SizedBox(),

                Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101));
                      if (picked != null) {
                        setState(() {
                          date = picked.toString().split(" ")[0];
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.black, width: 1)),
                      // alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Color.fromRGBO(7, 45, 68, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Tajawal'),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              // setState(() {
                              //   dateBool = !dateBool;
                              // });
                            },
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () async {
                    final TimeOfDay? picked_s = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(), builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );});
                    if (picked_s != null) {
                      setState(() {
                        if(picked_s.hour > 12){
                          time = "${picked_s.hour-12}:${picked_s.minute} ${picked_s.period.name}";
                        }else{
                          time = "${picked_s.hour}:${picked_s.minute} ${picked_s.period.name}";
                        }
                      });
                    }
                  },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.black, width: 1)),
                // alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              color: Color.fromRGBO(7, 45, 68, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        // setState(() {
                        //   dateBool = !dateBool;
                        // });
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),


                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(onPressed: (){

                  MyClient client = MyClient(
                    name: nameController.text.toString(),
                    service: activity,
                    price: double.parse(priceController.text.toString()),
                    phone: phoneController.text.toString(),
                    carNumber: carNumberController.text.toString(),
                    bookingTime: time,
                    bookingDate: date,
                    address: addressController.text.toString(),
                    email: emailController.text.toString(),
                  );

                  var db = DBHelper();

                  db.insert(client).then((value){
                    res = "${nameController.text},${carNumberController.text},$date,$time";

                    var enc = encryptionClass.encryptAES(res, "passwordpasswordpasswordpassword");

                    res = enc;

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext
                        context) =>
                            AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width/2,
                                height: MediaQuery.of(context).size.height/2.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/2,
                                      height: MediaQuery.of(context).size.height/3.8,
                                      child: RepaintBoundary(
                                        key: genKey,
                                        child: Screenshot(
                                          controller: screenshotController,
                                          child: QrImageView(
                                            data: res,
                                            version: QrVersions.auto,
                                            size: 120.0,
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(onPressed: () async {
                                      await saveToGallery();
                                    }, child: const Text("Save to gallery"))
                                  ],
                                ),
                              ),
                            ));
                  });



                }, child: const Text("Add Client")),

                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );
  }
}

class ListItem extends StatelessWidget {
  String text;
  ListItem({
    super.key,
    required this.text,
    required this.ifFirst,
    required this.ifLast,
  });

  bool ifFirst;
  bool ifLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
            bottom: ifLast ? const Radius.circular(10) : Radius.zero,
            top: ifFirst ? const Radius.circular(10) : Radius.zero),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Text(text),
    );
  }
}

class AppRouter {

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => const MyHome());
      case "/add":
        return MaterialPageRoute(
            builder: (_) => const Home());
    }
    return null;
  }
}