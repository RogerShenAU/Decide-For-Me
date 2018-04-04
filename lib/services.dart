import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';

class Services {

  final _googlePlaceAPIKey = 'YOUR_API_KEY';

  Location _location = new Location();

  String getPlatformMapUrl(){
    if(Platform.isIOS || Platform.isMacOS){
      return 'https://maps.apple.com/maps?q=';
    }else{
      return 'https://maps.google.com?q=';
    }
  }

  String getPlaceAPIUrl(Map<String, double> location, Map<String,String> params){

    if(location.containsKey('latitude') && location.containsKey('longitude')){
        double latitude = location['latitude'];
        double longitude = location['longitude'];
        String googlePlaceAPIUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location='+ latitude.toString() + ',' + longitude.toString() + '&radius=' + params['radius'].toString() + '&type=' + params['type'] + '&key=' + _googlePlaceAPIKey;

        return googlePlaceAPIUrl;
    }else{
      return '';
    }
  }

  String getPageTokenUrl(String pageToken){
    return 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=' + pageToken + '&key=' + _googlePlaceAPIKey;
  }

  Future<Map<String, double>> getCurrentGeoLocation() async {
    Map<String, double> location;
    try {
      location = await _location.getLocation;
    } catch (exception) {}
    
    return location;
  }

  Future fetchPost(String url) async {
    final response = await http.get(url);
    final json = JSON.decode(response.body);
    return json;
  }

  Future getAdditionalPlaces(url) async{
    final json = await fetchPost(url);
    if(json.containsKey('results')){
      return json['results'];
    }else{
      return null;
    }
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchMapByGeo(Map<String,double> geo) async {

    String mapUrl = getPlatformMapUrl();
    String url = '';

    if(geo != null && geo.containsKey('lat') && geo.containsKey('lng')){

      url = mapUrl + geo['lat'].toString() + ',' + geo['lng'].toString();

      launchURL(url);
    }else{
      throw 'Could not launch map!';
    }
  }

  launchMapByAddress(String address) async {

    String mapUrl = getPlatformMapUrl();
    String url = '';

    if(address != '' && address != null){
      address = address.replaceAll(new RegExp(r' '), '+');
      url = mapUrl + address;
      launchURL(url);
    }else{
      throw 'Could not launch map!';
    }
  }
}