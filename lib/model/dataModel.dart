import 'package:intl/intl.dart';

class Data {
  late double putOi;
  late double putOiChange;
  late double callOi;
  late double callOiChange;
  late String id;
  late String expirydate;
  late double strike;
  late String iv;

  Data(
      {required this.putOi,
        required  this.putOiChange,
        required  this.callOi,
        required  this.callOiChange,
        required this.id,
        required this.expirydate,
        required this.strike,
        required this.iv});

  Data.fromJson(Map<String, dynamic> json) {
    putOi = double.parse(json['put_oi']);
    putOiChange = double.parse(json['put_oi_change']);
    callOi = double.parse(json['call_oi']);
    callOiChange = double.parse(json['call_oi_change']);
    id = json['id'];
    expirydate = DateFormat("MMM dd yyyy").format(DateTime.fromMicrosecondsSinceEpoch(json['expirydate']*1000));
    strike = json['strike']/100;
    iv = json['iv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['put_oi'] = this.putOi;
    data['put_oi_change'] = this.putOiChange;
    data['call_oi'] = this.callOi;
    data['call_oi_change'] = this.callOiChange;
    data['id'] = this.id;
    data['expirydate'] = this.expirydate;
    data['strike'] = this.strike;
    data['iv'] = this.iv;
    return data;
  }
}