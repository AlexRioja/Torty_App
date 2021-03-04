
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Place {
  String name, formatted_address, icon,url, id, coordinates;

  Place({
    this.name,
    this.formatted_address,
    this.icon,
    this.url,
    this.id,
    this.coordinates
  });

  @override
  String toString() {
    return 'Place(name: $name, address: $formatted_address, icon: $icon, url: $url)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyDkXUAPkt4Zy16EFyjtQMRuc830jcEAVSw';
  static final String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Place>> fetchSuggestions(String input, String lang,String lon, String lat) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=establishment&components=country:es&language=$lang&key=$apiKey&sessiontoken=$sessionToken&location=$lat,$lon&radius=200&strictbounds=true';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        List<Suggestion> l_sug=result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
        List<Place> places= List<Place>();
        for (Suggestion s in l_sug){
          Place p=await getPlaceDetailFromId(s.placeId);
          places.add(p);
        }
        return places;
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,icon,url,geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print(result);
      if (result['status'] == 'OK') {
        final place = Place();
        place.formatted_address=result['result']['formatted_address'];
        place.name=result['result']['name'];
        place.icon=result['result']['icon'];
        place.url=result['result']['url'];
        place.coordinates=result['result']['geometry']['location']['lat'].toString()+';'+result['result']['geometry']['location']['lng'].toString();
        place.id=placeId;
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

}