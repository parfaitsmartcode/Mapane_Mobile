class Place {
  List<dynamic> coordinates;
  String country;
  String city;
  String osm_value;
  String name;
  String state;

  Place(
      {this.coordinates,
      this.country,
      this.city,
      this.osm_value,
      this.name,
      this.state});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        coordinates: json["geometry"]["coordinates"],
        city: json["properties"]["city"],
        country: json["properties"]["country"],
        osm_value: json["properties"]["osm_value"],
        name: json["properties"]["name"],
        state: json["properties"]["state"]);
  }
}
