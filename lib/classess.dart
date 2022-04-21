import 'package:faker/faker.dart';
import 'package:intl/intl.dart';

class Contact{
  String _user;
  String _phone;
  late String _dateTime;
  late DateTime _dt;
  
  String get user => _user;
  String get phone => _phone;
  String get dateTime => _dateTime;
  DateTime get dt => _dt;

  Contact(this._user, this._phone);

  Contact.withTimeString(this._user, this._phone, this._dateTime){
    _dt = DateTime.parse(dateTime);
  }
  
  factory Contact.randomContact(){
    var faker = Faker();
    var name = faker.person.name();
    var phone = RandomPhoneNumber(faker.randomGenerator).my();
    var randomDt = faker.date.dateTime(minYear: 2020, maxYear: 2021);
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(randomDt);
    return Contact.withTimeString(name, phone, formattedDate);
  }

  factory Contact.fromJson(dynamic json){
    return Contact.withTimeString(json['user'] as String, json['phone'] as String, json['check-in'] as String);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "{$user, $phone, $dateTime}";
  }

  String getTimeStampString(int currentTime){
    var timeStamp = currentTime - dt.millisecondsSinceEpoch;
    var duration = Duration(milliseconds: timeStamp);
    var seconds = duration.inSeconds;
    var minutes = duration.inMinutes;
    var hours = duration.inHours;
    var days = duration.inDays;

    if(days > 365) {
      return "${days~/365}y ago";
    }
    else if(days > 30){
      return "${days~/30}M ago";
    }
    else if(days >= 1 && days <= 30){
      return "${days}d ago";
    }
    else if(hours >= 1 && hours <= 23){
      return "${hours}h ago";
    }
    else if(minutes >=1 && minutes <= 59){
      return "${minutes}m ago";
    }
    else if(seconds < 60){
      return "Few seconds ago";
    }
    else if(seconds < 30){
      return "Just now";
    }
    
    return "";
  }
  
  Map toJson() => {
    'user': user,
    'phone':phone,
    'check-in' : dateTime,
  };
}

class Contacts{
  List<Contact> contactList;
  Contacts(this.contactList);

  factory Contacts.fromJson(dynamic json){
    if(json['_contacts'] != null){
      var contactList = json['_contacts'] as List;
      List<Contact> _contacts = contactList.map((e) => Contact.fromJson(e)).toList();
      return Contacts(_contacts);
    }
    else {
      return Contacts([]);
    }
  }

  void sortByTime(){
    contactList.sort((a, b){
      int aDate = a.dt.millisecondsSinceEpoch;
      int bDate = b.dt.millisecondsSinceEpoch;
      return bDate.compareTo(aDate);
    });
  }
  
  Map toJson() =>{
    '_contacts':contactList,
  };
}

class RandomPhoneNumber{
  static const MYPhoneNumberPatterns = [
    "01########",
    "01#########",
    "01#-#######",
    "01#-########",
  ];

  const RandomPhoneNumber(this.random);

  final RandomGenerator random;

  String my() => random.fromPattern(MYPhoneNumberPatterns);
}