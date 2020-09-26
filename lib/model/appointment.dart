import 'package:appointmentproject/model/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String _appointmentID;
  DocumentReference _professionalID;
  DocumentReference _serviceID;
  DocumentReference _subServicesID;
  Client _clientID;
  Timestamp _appointmentDateTime;
  Timestamp _appointmentDate;
  String _appointmentStatus;
  String _clientName;
  String _clientPhone;
  String _professionalName;
  String _professionalContact;
  String _serviceName;
  String _subServiceName;

  Appointment.bookAppointment();

  Map<String, dynamic> toMap(
      DocumentReference professionalID,
      DocumentReference serviceID,
      DocumentReference subServiceID,
      DocumentReference clientID,
      Timestamp appointmentDateTime,
      Timestamp appointmentDate,
      String appointmentStatus,
      String clientName,
      String clientPhone,
      String professionalName,
      String professionalContact,
      String serviceName,
      String subServiceName) {
    return {
      'professionalID': professionalID,
      'clientID': clientID,
      'serviceID': serviceID,
      'sub_serviceID': subServiceID,
      'appointment_date_time': appointmentDateTime,
      'appointment_date': appointmentDate,
      'appointment_status': appointmentStatus,
      'client_name': clientName,
      'client_phone': clientPhone,
      'professional_name': professionalName,
      'professional_contact': professionalContact,
      'service_name': serviceName,
      'sub_service_name': subServiceName
    };
  }

  Appointment.notAvailableTime(Map snapshot, String appointmentID)
      : _appointmentID = appointmentID,
        _appointmentDate = snapshot['appointment_date'],
        _appointmentDateTime = snapshot['appointment_date_time'];

  Appointment.getClientAppointments(
      Map snapshot, String appointmentID)
      : _appointmentID = appointmentID,
        _appointmentDate = snapshot['appointment_date'],
        _appointmentDateTime = snapshot['appointment_date_time'],
        _clientName = snapshot['client_name'],
        _clientPhone = snapshot['client_phone'],
        _professionalName = snapshot['professional_name'],
        _professionalContact = snapshot['professional_contact'],
        _serviceName = snapshot['service_name'],
        _subServiceName = snapshot['sub_service_name'],
        _professionalID = snapshot['professionalID'];

  String getAppointmentID() {
    return _appointmentID;
  }

  Client getClientReference() {
    return _clientID;
  }

  DocumentReference getProfessionalID() {
    return _professionalID;
  }

  DocumentReference getClientService() {
    return _serviceID;
  }

  DocumentReference getSubServices() {
    return _subServicesID;
  }

  Timestamp getAppointmentDateTime() {
    return _appointmentDateTime;
  }

  Timestamp getAppointmentDate() {
    return _appointmentDate;
  }

  String getAppointmentStatus() {
    return _appointmentStatus;
  }

  String getClientName() {
    return _clientName;
  }

  String getClientPhone() {
    return _clientPhone;
  }

  String getProfessionalName() {
    return _professionalName;
  }

  String getServiceName() {
    return _serviceName;
  }

  String getSubServiceName() {
    return _subServiceName;
  }

  String getProfessionalContact() {
    return _professionalContact;
  }
}
