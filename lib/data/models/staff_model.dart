///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class StaffsModelData {
/*
{
  "staff_id": 1,
  "staff_loc_id": 1,
  "staff_name": "James"
} 
*/

  int? staffId;
  int? staffLocId;
  String? staffName;

  StaffsModelData({
    this.staffId,
    this.staffLocId,
    this.staffName,
  });
  StaffsModelData.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id']?.toInt();
    staffLocId = json['staff_loc_id']?.toInt();
    staffName = json['staff_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['staff_id'] = staffId;
    data['staff_loc_id'] = staffLocId;
    data['staff_name'] = staffName;
    return data;
  }
}

class StaffsModel {
/*
{
  "data": [
    {
      "staff_id": 1,
      "staff_loc_id": 1,
      "staff_name": "James"
    }
  ]
} 
*/

  List<StaffsModelData?>? data;

  StaffsModel({
    this.data,
  });
  StaffsModel.fromJson(Map<String, dynamic> json) {
  if (json['data'] != null) {
  final v = json['data'];
  final arr0 = <StaffsModelData>[];
  v.forEach((v) {
  arr0.add(StaffsModelData.fromJson(v));
  });
    this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['data'] = arr0;
    }
    return data;
  }
}