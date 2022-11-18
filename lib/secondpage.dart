import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SecondPage extends StatefulWidget {
  SecondPage({required this.city});

  String city;

  @override
  State<SecondPage> createState() => _SecondPageState();
}



class _SecondPageState extends State<SecondPage> {
  @override
  var weatherEmoji = "";
  Widget build(BuildContext context) {



    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('image/background.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Results",
            style: TextStyle(
                fontSize: 30, color: Colors.white),
          ),
        ),
        body: Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [FutureBuilder(future: apicall(widget.city),
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(snapshot.data["description"].toString(),
                                style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text("TEMPERATURE: "+ snapshot.data["temp"].round().toString()+ " degrees Celcius", style: TextStyle(color: Colors.white70),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text("HUMIDITY: " +snapshot.data["humidity"].toString(), style: TextStyle(color: Colors.white70)),
                          ),

                        ],
                      );
                    } else { return
                      Text("");
                    }

                  }
              )



              ],
            )

        ),
      ),
    );

  }
}
Future apicall(city) async {
  final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q="+city+"&appid=8875a46932e3e98fc148dabdac8af3ff");
  final response = await http.get(url);
  print(response.body);
  final json = jsonDecode(response.body);
  print(json["weather"][0]["main"]);

  final output = {
    'windspd': json["wind"]['speed'],
    'winddir':json["wind"]['deg'],
    'description': json["weather"][0]['description'],
    'temp': json["main"]['temp'] - 273,
    'feelslike': json["main"]['feels_like'] - 273,
    'min': json["main"]['temp_min'] - 273,
    'max': (json["main"]['temp_max'] - 273),
    'pressure': json["main"]['pressure'],
    'humidity': json["main"]['humidity']

  };
  return output;
}