class TripModel {
  int tripId;
  int carId;
  int invoiceId;
  double tripDistance;
  String tripStartDate;
  String tripEndDate;
  double tripPrice;
  int tripStatus;

  TripModel(
      {this.tripId,
      this.carId,
      this.invoiceId,
      this.tripDistance,
      this.tripStartDate,
      this.tripEndDate,
      this.tripPrice,
      this.tripStatus});

  TripModel.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    carId = json['car_id'];
    invoiceId = json['invoice_id'];
    tripDistance = json['trip_distance'];
    tripStartDate = json['trip_start_date'];
    tripEndDate = json['trip_end_date'];
    tripPrice = json['trip_price'];
    tripStatus = json['trip_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['car_id'] = this.carId;
    data['invoice_id'] = this.invoiceId;
    data['trip_distance'] = this.tripDistance;
    data['trip_start_date'] = this.tripStartDate;
    data['trip_end_date'] = this.tripEndDate;
    data['trip_price'] = this.tripPrice;
    data['trip_status'] = this.tripStatus;
    return data;
  }
}
