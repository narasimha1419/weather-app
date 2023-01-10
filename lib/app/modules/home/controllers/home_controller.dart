import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  determinePosition() async {
    isLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getweatherInfo(false);
        // return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        getweatherInfo(false);
      } else {
        getweatherInfo(true);
      }
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getweatherInfo(false);
        // return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        getweatherInfo(false);
      } else {
        getweatherInfo(true);
      }
    } else if (permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getweatherInfo(false);
        // return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        getweatherInfo(false);
      } else {
        getweatherInfo(true);
      }
    } else {
      getweatherInfo(true);
    }
  }

  final localStoage = GetStorage();
  RxBool isLoading = false.obs;
  getweatherInfo(isPostionGot) async {
    var apiKey = '05ed7d3a60374c8f840171631231001';
    var url;
    if (isPostionGot) {
      Position position = await Geolocator.getCurrentPosition();
      url =
          'http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${position.latitude.toString()},${position.longitude.toString()}&days=7';
    } else {
      url =
          'http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=india&days=7';
    }
    // print("position.latitude" + position.latitude.toString());
    print(url);
    try {
      var request = http.Request('GET', Uri.parse(url));

      http.StreamedResponse response = await request.send();
      // print(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        var json = await response.stream.bytesToString();
        print(jsonDecode(json));
        localStoage.write('weatherInfo', jsonDecode(json));
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print(response.statusCode);
      }
    } catch (e) {
      isLoading.value = false;
      print('error ' + e.toString());
    }
  }

  getTime(date) {
    // DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(DateTime.parse(date));
    print(formattedTime);
    return formattedTime;
  }

  getDay(date) {
    String day = DateFormat('EEEE').format(DateTime.parse(date));
    return day;
  }

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  onInit() {
    super.onInit();
    determinePosition();
  }

  onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
