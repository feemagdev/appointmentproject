part of 'professional_dashboard_bloc.dart';

@immutable
abstract class ProfessionalDashboardEvent {}


class ProfessionalAddAppointmentEvent extends ProfessionalDashboardEvent {
  final Professional professional;
  ProfessionalAddAppointmentEvent({@required this.professional});
}

class ProfessionalEditAppointmentEvent extends ProfessionalDashboardEvent {
  final Professional professional;
  ProfessionalEditAppointmentEvent({@required this.professional});
}