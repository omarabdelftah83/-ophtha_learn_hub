import 'package:flutter/material.dart';

class Constants {
  
  
  static const dommain = 'https://appmentalskillacademy.anmka.com';
  static const baseUrl = '$dommain/api/development/';

  // static const baseUrl = '$dommain/api/';
  static const apiKey = '2252';
  static const scheme = 'academyapp';
  
  static final RouteObserver<ModalRoute<void>> singleCourseRouteObserver = RouteObserver<ModalRoute<void>>();
  static final RouteObserver<ModalRoute<void>> contentRouteObserver = RouteObserver<ModalRoute<void>>();

}
